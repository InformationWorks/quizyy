# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.delete_all
User.delete_all
Category.delete_all
Topic.delete_all
Type.delete_all
QuizType.delete_all
SectionType.delete_all
Quiz.delete_all
Section.delete_all
Question.delete_all

super_admin_role = Role.new
super_admin_role.name = "SuperAdmin"
super_admin_role.save!

admin_role = Role.new
admin_role.name = "Admin"
admin_role.save!

publisher_role = Role.new
publisher_role.name = "Publisher"
publisher_role.save!

student_role = Role.new
student_role.name = "Student"
student_role.save!

super_admin_user = User.create!(:full_name => 'Harshal Bhakta', :email => 'harshal.c.bhakta@gmail.com', :password => 'password', :password_confirmation => 'password')
super_admin_user.roles << super_admin_role
super_admin_user.save!

[ { :code => "RC", :name => "Reading Comprehension"}, 
  { :code => "TC", :name => "Text Completion"},
  { :code => "SE", :name => "Sentence Equivalence"},
  { :code => "QC", :name => "Quantitative Comparison"},
  { :code => "MCQ", :name => "Multiple choice"},
  { :code => "NE", :name => "Numeric Entry"},
  { :code => "DI-MCQ", :name => "Data Interpretation-Multiple choice"},
  { :code => "DI-NE", :name => "Data Interpretation-Numeric Entry"},].each do |category|
  Category.find_or_create_by_code_and_name(category[:code],category[:name])
end

["Integers",
"Fractions",
"Decimals",
"Exponents and Square Roots",
"Ordering and the Real Number Line",
"Percent",
"Ratio and Proportion",
"Absolute Value",
"Averages & Weighted Averages",
"Time and Work",
"Time, Speed and Distance",
"Algebraic Expressions",
"Rules of Exponents",
"Linear and Quadratic Equations",
"Graphs",
"Inequalities",
"Co-ordinate Geometry",
"Functions",
"Geometry",
"Probability",
"Permutation and Combination",
"Measures of Central Location",
"Data Representation and Interpretation",
"Measures of Dispersion",
"Frequency Distribution",
"Advanced Statistics"].each do |topic_name|
  Topic.find_or_create_by_name topic_name
end

[ { :code => "V-MCQ-1", :name => "Verbal - Select 1 of 5", :category => Category.find_by_code("RC") }, 
  { :code => "V-MCQ-2", :name => "Verbal - Select all correct of 3", :category => Category.find_by_code("RC") },
  { :code => "V-SIP",   :name => "Verbal - Select in passage", :category => Category.find_by_code("RC") },
  { :code => "V-TC-1",  :name => "Verbal - Text completion [1 Blank,5 Options]", :category => Category.find_by_code("TC") },
  { :code => "V-TC-2",  :name => "Verbal - Text completion [2 Blank,6 Options]", :category => Category.find_by_code("TC") },
  { :code => "V-TC-3",  :name => "Verbal - Text completion [3 Blank,9 Options]", :category => Category.find_by_code("TC") },
  { :code => "V-SE",    :name => "Verbal - Sentence Equivalance [1 Blank,6 Options]", :category => Category.find_by_code("SE") },
  { :code => "Q-QC",    :name => "Quant - Compare A/B", :category => Category.find_by_code("QC") },
  { :code => "Q-MCQ-1",    :name => "Quant - Select 1 of 5", :category => Category.find_by_code("MCQ") },
  { :code => "Q-MCQ-2",    :name => "Quant - Select all correct", :category => Category.find_by_code("MCQ") },
  { :code => "Q-NE-1",     :name => "Quant - NE [ 1 Textbox ]", :category => Category.find_by_code("NE") },
  { :code => "Q-NE-2",     :name => "Quant - NE [ 2 Textboxes ]", :category => Category.find_by_code("NE") },
  { :code => "Q-DI-MCQ-1", :name => "Quant - DI + MCQ1", :category => Category.find_by_code("DI-MCQ") },
  { :code => "Q-DI-MCQ-2", :name => "Quant - DI + MCQ2", :category => Category.find_by_code("DI-MCQ") },
  { :code => "Q-DI-NE-1",  :name => "Quant - DI + NE1", :category => Category.find_by_code("DI-NE") },
  { :code => "Q-DI-NE-2",  :name => "Quant - DI + NE2", :category => Category.find_by_code("DI-NE") }].each do |type_hash|
  
    type = Type.find_by_code(type_hash[:code]) 
    
    if(!type)
      type = Type.create(:code => type_hash[:code],:name => type_hash[:name])
      type.category = type_hash[:category]
      type.save!
    end
  
  end
  
  ["FullQuiz", "CategoryQuiz", "TopicQuiz"].each do | quiz_type_name |
    QuizType.find_or_create_by_name(quiz_type_name)
  end
  
  ["Verbal", "Quant"].each do | section_type_name |
    SectionType.find_or_create_by_name_and_instruction(section_type_name,"Total Questions: 20 & Total Time: 30 minutes")
  end
  
  # Seed data for quiz.
  # Create 10 FullLengthQuiz
  full_quiz_1 = Quiz.new
  full_quiz_1.name = "Full Length 1"
  full_quiz_1.random = false
  full_quiz_1.quiz_type_id = QuizType.find_by_name("FullQuiz").id
  full_quiz_1.save!
  
  full_quiz_2 = Quiz.new
  full_quiz_2.name = "Full Length 2"
  full_quiz_2.random = false
  full_quiz_2.quiz_type_id = QuizType.find_by_name("FullQuiz").id
  full_quiz_2.save!
  
  full_quiz_3 = Quiz.new
  full_quiz_3.name = "Full Length 3"
  full_quiz_3.random = false
  full_quiz_3.quiz_type_id = QuizType.find_by_name("FullQuiz").id
  full_quiz_3.save!
  
  full_quiz_4 = Quiz.new
  full_quiz_4.name = "Full Length 4"
  full_quiz_4.random = false
  full_quiz_4.quiz_type_id = QuizType.find_by_name("FullQuiz").id
  full_quiz_4.save!
  
  full_quiz_5 = Quiz.new
  full_quiz_5.name = "Full Length 5"
  full_quiz_5.random = false
  full_quiz_5.quiz_type_id = QuizType.find_by_name("FullQuiz").id
  full_quiz_5.save!
  
  full_quiz_6 = Quiz.new
  full_quiz_6.name = "Full Length 6"
  full_quiz_6.random = false
  full_quiz_6.quiz_type_id = QuizType.find_by_name("FullQuiz").id
  full_quiz_6.save!
  
  full_quiz_7 = Quiz.new
  full_quiz_7.name = "Full Length 7"
  full_quiz_7.random = false
  full_quiz_7.quiz_type_id = QuizType.find_by_name("FullQuiz").id
  full_quiz_7.save!
  
  full_quiz_8 = Quiz.new
  full_quiz_8.name = "Full Length 8"
  full_quiz_8.random = false
  full_quiz_8.quiz_type_id = QuizType.find_by_name("FullQuiz").id
  full_quiz_8.save!
  
  full_quiz_9 = Quiz.new
  full_quiz_9.name = "Full Length 9"
  full_quiz_9.random = false
  full_quiz_9.quiz_type_id = QuizType.find_by_name("FullQuiz").id
  full_quiz_9.save!
  
  full_quiz_10 = Quiz.new
  full_quiz_10.name = "Full Length 10"
  full_quiz_10.random = false
  full_quiz_10.quiz_type_id = QuizType.find_by_name("FullQuiz").id
  full_quiz_10.save!
  
  # Create 5 Category-wise quiz
  cat_quiz_1 = Quiz.new
  cat_quiz_1.name = "Reading Comprehension 1"
  cat_quiz_1.random = false
  cat_quiz_1.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  cat_quiz_1.category_id = Category.find_by_code("RC").id
  cat_quiz_1.save!
  
  cat_quiz_2 = Quiz.new
  cat_quiz_2.name = "Text Completion 1"
  cat_quiz_2.random = false
  cat_quiz_2.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  cat_quiz_2.category_id = Category.find_by_code("RC").id
  cat_quiz_2.save!
  
  cat_quiz_3 = Quiz.new
  cat_quiz_3.name = "Sentence Equivalence 1"
  cat_quiz_3.random = false
  cat_quiz_3.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  cat_quiz_3.category_id = Category.find_by_code("RC").id
  cat_quiz_3.save!
  
  cat_quiz_4 = Quiz.new
  cat_quiz_4.name = "Quantitative Comparison 1"
  cat_quiz_4.random = false
  cat_quiz_4.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  cat_quiz_4.category_id = Category.find_by_code("RC").id
  cat_quiz_4.save!
  
  cat_quiz_5 = Quiz.new
  cat_quiz_5.name = "Numeric Entry 1"
  cat_quiz_5.random = false
  cat_quiz_5.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  cat_quiz_5.category_id = Category.find_by_code("RC").id
  cat_quiz_5.save!
  
  # Create 5 Topic-wise quiz
  topic_quiz_1 = Quiz.new
  topic_quiz_1.name = "Integers 1"
  topic_quiz_1.random = false
  topic_quiz_1.quiz_type = QuizType.find_by_name("TopicQuiz")
  topic_quiz_1.topic_id = Topic.find_by_name("Integers").id
  topic_quiz_1.save!
  
  topic_quiz_1 = Quiz.new
  topic_quiz_1.name = "Fractions 1"
  topic_quiz_1.random = false
  topic_quiz_1.quiz_type = QuizType.find_by_name("TopicQuiz")
  topic_quiz_1.topic_id = Topic.find_by_name("Fractions").id
  topic_quiz_1.save!
  
  topic_quiz_1 = Quiz.new
  topic_quiz_1.name = "Decimals 1"
  topic_quiz_1.random = false
  topic_quiz_1.quiz_type = QuizType.find_by_name("TopicQuiz")
  topic_quiz_1.topic_id = Topic.find_by_name("Decimals").id
  topic_quiz_1.save!
  
  topic_quiz_1 = Quiz.new
  topic_quiz_1.name = "Exponents and Square Roots 1"
  topic_quiz_1.random = false
  topic_quiz_1.quiz_type = QuizType.find_by_name("TopicQuiz")
  topic_quiz_1.topic_id = Topic.find_by_name("Exponents and Square Roots").id
  topic_quiz_1.save!
  
  topic_quiz_1 = Quiz.new
  topic_quiz_1.name = "Ordering and the Real Number Line 1"
  topic_quiz_1.random = false
  topic_quiz_1.quiz_type = QuizType.find_by_name("TopicQuiz")
  topic_quiz_1.topic_id = Topic.find_by_name("Ordering and the Real Number Line").id
  topic_quiz_1.save!

