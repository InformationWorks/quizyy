class QuestionsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /questions
  # GET /questions.json
  def index
    
    load_questions

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions, :include => [:type] }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    
    load_quiz_and_section
    load_question

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    
    load_quiz_and_section
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/1/edit
  def edit
    load_quiz_and_section
    load_question
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(params[:question])
    @question.section_id = params[:section_id]

    respond_to do |format|
      if @question.save
        format.html { redirect_to [@question.section.quiz,@question.section,@question], notice: 'Question was successfully created.' }
        format.json { render json: [@question.section.quiz,@question.section,@question], status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    
    load_question

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to [@question.section.quiz,@question.section,@question], notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    
    load_question
    
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
  
  private

  def load_quiz_and_section
    @quiz = Quiz.find params[:quiz_id]
    @section = Section.find params[:section_id]
  end
  
  def load_questions
    @questions = Question.where(:section_id => params[:section_id])
  end
  
  def load_question
    @question = Question.find(params[:id])
  end
  
end
