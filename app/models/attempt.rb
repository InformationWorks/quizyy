class Attempt < ActiveRecord::Base
  serialize :report, ::ActiveRecord::Coders::Hstore
  belongs_to :user
  belongs_to :quiz
  attr_accessible :user_id, :quiz_id, :completed, :current_question_id,:current_section_id, :is_current,:current_time
  scope :all_score_for_user, (
    lambda do |user_id|
      includes(:quiz).merge(Quiz.full).where('score IS NOT NULL and attempts.completed = true and attempts.user_id =?',user_id).select(:score) unless user_id.nil?
    end
  )
  scope :all_reports_for_user, (
    lambda do |user_id|
      includes(:quiz).merge(Quiz.full).where('score IS NOT NULL and attempts.completed = true and attempts.user_id =?',user_id).select(:report).all() unless user_id.nil?
    end
  )

  def self.max_score_for_user(user_id)
    all_score_for_user(user_id).maximum(:score)
  end

  def self.avg_score_for_user(user_id)
    all_score_for_user(user_id).average(:score)
  end

  def self.section_scores_for_user(user_id)
    reports = all_reports_for_user(user_id)
    reports.each do |model|
      model[:report].each{|k,v| model[:report][k] = eval(v)}
    end
    section_types = SectionType.all()
    section_scores = reports.inject(Hash[:verbal=>{:avg=>0,:max=>0},:quant=>{:avg=>0,:max=>0}]) do |section_scores,model|
      main_section_report = Hash[section_types.map{|t| [t.name, Hash['correct' => 0,'total' =>0 ]]}]

      model[:report]['section_report'].each do |k,v|
        main_section_report[v['section_type']]['correct'] += v['correct']
        main_section_report[v['section_type']]['total'] += v['total']
      end
      v_score = ScaledScore.convert(:verbal,main_section_report['Verbal']['correct'].to_f*100/main_section_report['Verbal']['total'])
      q_score = ScaledScore.convert(:quant,main_section_report['Quant']['correct']*100/main_section_report['Quant']['total'])
      section_scores[:verbal][:avg] += v_score
      section_scores[:quant][:avg] += q_score
      section_scores[:verbal][:max] = section_scores[:verbal][:max] < v_score ?  v_score : section_scores[:verbal][:max]
      section_scores[:quant][:max] = section_scores[:quant][:max] < q_score ? q_score : section_scores[:quant][:max]
      section_scores
    end
    section_scores[:verbal][:avg] /= reports.length unless reports.length == 0
    section_scores[:quant][:avg] /= reports.length  unless reports.length == 0
    section_scores
  end
  def set_attempt_as_current
    Attempt.where('user_id = ?',self.user.id).each do |attempt|
      attempt.is_current = false
      attempt.save
    end
    self.is_current = true
    self.save
  end

  def calculate_score
    quiz = Quiz.includes(:category,:topic).find(self.quiz_id)
    attempt_details = AttemptDetail.find_all_by_attempt_id(self.id)
    sections = Section.with_all_association_data.find_all_by_quiz_id(self.quiz_id)
    #types = Type.includes(:category).all()
    section_report ={}
    #type_report = Hash[ types.map{|t| [t.code,Hash['correct'=>0,'total'=>0,'category_code'=> t.category.code, 'category_name' => t.category.name]]}]
    questions_have_no_options = %w(V-SIP Q-NE-1 Q-NE-2 Q-DI-NE-1 Q-DI-NE-2)
    section_types = SectionType.all()
    main_section_report = Hash[section_types.map{|t| [t.name, Hash['correct' => 0,'total' =>0 ]]}]
    total_correct = 0
    total_question = 0
    sections.each do |section|
      correct = 0
      section.questions.each do |question|
        if questions_have_no_options.include?(question.type.code)
          correct_answers = question.options.collect{|o| o.content}.first().to_s()
          user_answers = attempt_details.find_all{ |a| a.question_id==question.id}.collect{|a| a.user_input}.first().to_s()
        else
          correct_answers = question.options.find_all{ |o| o.correct }.collect{|o| o.id }.sort().join(',')
          user_answers = attempt_details.find_all{ |a| a.question_id==question.id }.collect{|a| a.option_id}.sort.join(',')
        end
        if user_answers!="" and correct_answers == user_answers
          correct +=1
          total_correct+=1
          #type_report[question.type.code]['correct'] += 1
        end
        #type_report[question.type.code]['total'] += 1
        total_question += 1
      end
      main_section_report[section.section_type.name]['correct'] += correct
      main_section_report[section.section_type.name]['total'] += section.questions.length
      section_report[section.id.to_s] = {'section_name' => section.name,'section_type'=> section.section_type.name,'correct'=> correct,'total'=> section.questions.length}
    end

    main_section_report.delete_if { |k,v| v['total']==0}
    #type_report.delete_if { |k,v| v['total']==0 }
    self.report = Hash['main_section_report' => main_section_report,'section_report' => section_report, 'type_report'=> {}, 'total'=> {'correct' => total_correct,'questions' => total_question}]
    self.score = 0
    if quiz.quiz_type.name == 'FullQuiz' or quiz.quiz_type.name == 'SectionQuiz'
      main_section_report.each do |key,value|
          self.score +=  value['total'] != 0 ? ScaledScore.convert(key.downcase.to_sym,value['correct']*100/value['total']) : 0
      end
    else
      self.score +=  total_correct*100/total_question
    end
    self.save
    self
  end

  def get_with_highest_score
    Attempt.joins(:quiz).where('quizzes.quiz_type_id=? and attempts.quiz_id=? and score IS NOT NULL',self.quiz.quiz_type_id,self.quiz_id).order('score  DESC').first()
  end

  #to search attempts of a quiz based on the date of attempt
  def self.search_by_date_and_quiz_id(date,quiz_id)
    Attempt.where('DATE(created_at) = DATE(?) and quiz_id = ?', date, quiz_id)
  end
end
