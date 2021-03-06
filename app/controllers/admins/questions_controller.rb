module Admins
  class QuestionsController < ApplicationController
    
    before_filter :authenticate_user!
    
    # GET /questions
    # GET /questions.json
    def index
      
      load_quiz_and_section
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
      load_quiz_and_section
      
      que_image = params[:question].delete :que_image
      sol_image = params[:question].delete :sol_image 
      
      # handle empty que_image
      if que_image != nil && que_image.strip == ""
        que_image = nil
      end
      
      # handle empty que_image
      if sol_image != nil && sol_image.strip == ""
        sol_image = nil
      end 
      
      @question = Question.new(params[:question])
      @question.section_id = @section.id
      @question.que_image = que_image
      @question.sol_image = sol_image
  
      respond_to do |format|
        if @question.save
          format.html { redirect_to admins_quiz_section_question_path(@question.section.quiz,@question.section,@question.sequence_no), notice: 'Question was successfully created.' }
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
      
      load_quiz_and_section
      load_question
      
      que_image = params[:question].delete :que_image
      sol_image = params[:question].delete :sol_image 
      
      # handle empty que_image
      if que_image != nil && que_image.strip == ""
        que_image = nil
      end
      
      # handle empty que_image
      if sol_image != nil && sol_image.strip == ""
        sol_image = nil
      end
      
      @question.attributes = params[:question]
      @question.que_image = que_image
      @question.sol_image = sol_image
  
      respond_to do |format|
        if @question.save
          format.html { redirect_to [:admins,@question.section.quiz,@question.section,@question], notice: 'Question was successfully updated.' }
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
      
      load_quiz_and_section
      load_question
      
      @question.destroy
  
      respond_to do |format|
        format.html { redirect_to admins_quiz_section_path(@quiz,@section), notice: 'Question was successfully deleted.'  }
        format.json { head :no_content }
      end
    end
    
    private
  
    def load_quiz_and_section
      @quiz = Quiz.find_by_slug!(params[:quiz_id])
      @section = @quiz.sections.find_by_slug!(params[:section_id])
    end
    
    def load_questions
      @questions = @section.questions
    end
    
    def load_question
      @question = @section.questions.find_by_sequence_no(params[:id])
    end
    
  end
end