module Admins
  class OptionsController < ApplicationController
    
    before_filter :authenticate_user!
    
    # GET /options
    # GET /options.json
    def index
  
      load_options
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @options }
      end
    end
  
    # GET /options/1
    # GET /options/1.json
    def show
  
      load_quiz_section_and_question
      load_option
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @option }
      end
    end
  
    # GET /options/new
    # GET /options/new.json
    def new
  
      load_quiz_section_and_question
      @option = Option.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @option }
      end
    end
  
    # GET /options/1/edit
    def edit
      load_quiz_section_and_question
      load_option
    end
  
    # POST /options
    # POST /options.json
    def create
      
      load_quiz_section_and_question
      
      @option = Option.new(params[:option])
      @option.question_id = @question.id
  
      respond_to do |format|
        if @option.save
          format.html { redirect_to admins_quiz_section_question_path(@quiz,@section,@question.sequence_no), notice: 'Option was successfully created.' }
          format.json { render json: [@option.question.section.quiz,@option.question.section,@option.question,@option], status: :created, location: @option }
        else
          format.html { render action: "new" }
          format.json { render json: @option.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /options/1
    # PUT /options/1.json
    def update
  
      load_quiz_section_and_question
      load_option
  
      respond_to do |format|
        if @option.update_attributes(params[:option])
          format.html { redirect_to admins_quiz_section_question_path(@quiz,@section,@question.sequence_no), notice: 'Option was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @option.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /options/1
    # DELETE /options/1.json
    def destroy
    
      load_quiz_section_and_question
      load_option
  
      @option.destroy
  
      respond_to do |format|
        format.html { redirect_to admins_quiz_section_question_path(@quiz,@section,@question.sequence_no), notice: "Option deleted successfully." }
        format.json { head :no_content }
      end
    end
  
    def load_quiz_section_and_question
      @quiz = Quiz.find_by_slug!(params[:quiz_id])
      @section = @quiz.sections.find_by_slug!(params[:section_id])
      @question = @section.questions.find_by_sequence_no(params[:question_id])
    end
  
    def load_options
      @options = @question.options
    end
  
    def load_option
      @option = @question.options.find_by_sequence_no(params[:id])
    end
  
  end
end