class SectionsController < ApplicationController
  # GET /sections
  # GET /sections.json
  def index
    
    load_quiz
    load_sections
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sections }
    end
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
    
    load_section
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @section }
    end
  end

  # GET /sections/new
  # GET /sections/new.json
  def new
    
    load_quiz
    @section = Section.new
   
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @section }
    end
  end

  # GET /sections/1/edit
  def edit
    
    load_quiz
    load_section
    
    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @section }
    end
  end

  # POST /sections
  # POST /sections.json
  def create
    
    @section = Section.new(params[:section])
    @section.quiz_id = params[:quiz_id]
    
    respond_to do |format|
      if @section.save
        format.html { redirect_to [@section.quiz,@section], notice: 'Section was successfully created.' }
        format.json { render json: [@section.quiz,@section], status: :created, location: @section }
      else
        format.html { render action: "new" }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sections/1
  # PUT /sections/1.json
  def update
    
    load_section

    respond_to do |format|
      if @section.update_attributes(params[:section])
        format.html { redirect_to [@section.quiz,@section], notice: 'Section was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    
    load_section
    
    @section.destroy

    respond_to do |format|
      format.html { redirect_to sections_url }
      format.json { head :no_content }
    end
  end
  
  private

  def load_quiz
    @quiz = Quiz.find params[:quiz_id]
  end
  
  def load_sections
    @sections = Section.where(:quiz_id => params[:quiz_id])
  end
  
  def load_section
    @section = Section.find(params[:id])
  end
  
end
