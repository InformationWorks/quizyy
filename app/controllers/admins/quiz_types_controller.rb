module Admins
  class QuizTypesController < ApplicationController
    
    before_filter :authenticate_user!
    before_filter :load_quiz_type, :only => [ :show, :edit, :update, :destroy ]
    load_and_authorize_resource :find_by => :slug
    
    # GET /quiz_types
    # GET /quiz_types.json
    def index
      @quiz_types = QuizType.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @quiz_types }
      end
    end
  
    # GET /quiz_types/1
    # GET /quiz_types/1.json
    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @quiz_type }
      end
    end
  
    # GET /quiz_types/new
    # GET /quiz_types/new.json
    def new
      @quiz_type = QuizType.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @quiz_type }
      end
    end
  
    # GET /quiz_types/1/edit
    def edit
    end
  
    # POST /quiz_types
    # POST /quiz_types.json
    def create
      @quiz_type = QuizType.new(params[:quiz_type])
  
      respond_to do |format|
        if @quiz_type.save
          format.html { redirect_to [:admins, @quiz_type], notice: 'Quiz type was successfully created.' }
          format.json { render json: @quiz_type, status: :created, location: @quiz_type }
        else
          format.html { render action: "new" }
          format.json { render json: @quiz_type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /quiz_types/1
    # PUT /quiz_types/1.json
    def update
      respond_to do |format|
        if @quiz_type.update_attributes(params[:quiz_type])
          format.html { redirect_to [:admins, @quiz_type], notice: 'Quiz type was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @quiz_type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /quiz_types/1
    # DELETE /quiz_types/1.json
    def destroy
      
      @quiz_type.destroy
  
      respond_to do |format|
        format.html { redirect_to admins_quiz_types_url, notice: 'Quiz type was successfully deleted.'  }
        format.json { head :no_content }
      end
    end
    
    private
    
    def load_quiz_type
      @quiz_type = QuizType.find_by_slug!(params[:id])
    end  
    
  end
end