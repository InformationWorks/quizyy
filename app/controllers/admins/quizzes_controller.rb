module Admins
  class QuizzesController < ApplicationController
    
    before_filter :authenticate_user!
    before_filter :load_quiz, :only => [ :show, :edit, :update, :destroy ]
    load_and_authorize_resource :find_by => :slug
    
    include UploadExcel
    
    # GET /quizzes
    # GET /quizzes.json
    def index
      
      ####
      # TODO: It might be more efficient to load all the quizzes in memory first
      # and then construct different arrays instead of using multiple queries.
      ####
      @full_quizzes = Quiz.full
      @section_quizzes = Quiz.section
      @category_quizzes = Quiz.category
      @topic_quizzes = Quiz.topic
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @quizzes }
      end
    end
  
    # GET /quizzes/1
    def show
      
      @upload_path = upload_excel_path    
      
      respond_to do |format|
        format.html # show.html.erb
      end
    end
  
    # GET /quizzes/new
    # GET /quizzes/new.json
    def new
      @quiz = Quiz.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @quiz }
      end
    end
  
    # GET /quizzes/1/edit
    def edit
    end
  
    # POST /quizzes
    # POST /quizzes.json
    def create
      @quiz = Quiz.new(params[:quiz])
      
      if @quiz.quiz_type_id == QuizType.find_by_name("FullQuiz").id
        @quiz.category_id = nil
        @quiz.topic_id = nil
        @quiz.section_type_id = nil
      elsif @quiz.quiz_type_id == QuizType.find_by_name("CategoryQuiz").id
        @quiz.topic_id = nil
        @quiz.section_type_id = nil
      elsif @quiz.quiz_type_id == QuizType.find_by_name("TopicQuiz").id
        @quiz.category_id = nil
        @quiz.section_type_id = nil
      elsif @quiz.quiz_type_id == QuizType.find_by_name("SectionQuiz").id
        @quiz.category_id = nil
        @quiz.topic_id = nil
      end
  
      respond_to do |format|
        if @quiz.save
          format.html { redirect_to [:admins, @quiz], notice: 'Quiz was successfully created.' }
          format.json { render json: @quiz, status: :created, location: @quiz }
        else
          format.html { render action: "new" }
          format.json { render json: @quiz.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /quizzes/1
    # PUT /quizzes/1.json
    def update
      
      # If quiz type is "FullQuiz" then category_id & topic_id should be nil
      # Step 1: Remove category_id & topic_id from params hash
      # Step 2: Set category_id & topic_id as nil
      if params[:quiz][:quiz_type_id] == QuizType.find_by_name("FullQuiz").id.to_s
        params[:quiz].delete :category_id
        params[:quiz].delete :topic_id
        
        @quiz.category_id = nil
        @quiz.topic_id = nil
      elsif params[:quiz][:quiz_type_id] == QuizType.find_by_name("CategoryQuiz").id
        params[:quiz].delete :topic_id
        params[:quiz].delete :section_type_id
        
        @quiz.topic_id = nil
        @quiz.section_type_id = nil
      elsif params[:quiz][:quiz_type_id] == QuizType.find_by_name("TopicQuiz").id
        params[:quiz].delete :category_id
        params[:quiz].delete :section_type_id
        
        @quiz.category_id = nil
        @quiz.section_type_id = nil
      elsif params[:quiz][:quiz_type_id] == QuizType.find_by_name("SectionQuiz").id
        params[:quiz].delete :category_id
        params[:quiz].delete :topic_id
        
        @quiz.category_id = nil
        @quiz.topic_id = nil
      end
  
      respond_to do |format|
        if @quiz.update_attributes(params[:quiz])
          format.html { redirect_to [:admins , @quiz], notice: 'Quiz was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @quiz.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /quizzes/1
    # DELETE /quizzes/1.json
    def destroy
      
      @quiz.destroy
  
      respond_to do |format|
        format.html { redirect_to admins_quizzes_url, notice: 'Quiz was successfully deleted.' }
        format.json { head :no_content }
      end
    end
    
    # Upload full legth test excel
    def upload_full_excel
      
      quiz = Quiz.find_by_slug!(params[:id])
      
      if params[:quiz][:dry_run] == "true"
        dry_run = true
      else
        dry_run = false
      end
      
      full_quiz_uploader = FullQuizUploader.new(getWorkbookFromParams(params),quiz,dry_run)
      
      if full_quiz_uploader.validate_excel_workbook
        # Valid Excel
        
        if full_quiz_uploader.execute_excel_upload
          # Excel upload executed successfully.
          redirect_to  admins_quiz_path(quiz), :flash => { :success_messages => full_quiz_uploader.success_messages }
        else
          # Excel upload failed.
          redirect_to  admins_quiz_path(quiz), :flash => { :error_messages => full_quiz_uploader.error_messages }
        end
        
      else
        # Invalid Excel
        redirect_to  admins_quiz_path(quiz), :flash => { :error_messages => full_quiz_uploader.error_messages }
      end
      
    end
    
    # Upload verbal test excel
    def upload_verbal_excel
      
      quiz = Quiz.find_by_slug!(params[:id])
      
      if params[:quiz][:dry_run] == "true"
        dry_run = true
      else
        dry_run = false
      end
      
      verbal_quiz_uploader = VerbalQuizUploader.new(getWorkbookFromParams(params),quiz,dry_run)
      
      if verbal_quiz_uploader.validate_excel_workbook
        # Valid Excel
        
        if verbal_quiz_uploader.execute_excel_upload
          # Excel upload executed successfully.
          #render :json => { :message => "Valid and uploaded correctly",:success => full_quiz_uploader.success_messages.to_s }
          redirect_to  admins_quiz_path(quiz), :flash => { :success_messages => verbal_quiz_uploader.success_messages }
        else
          # Excel upload failed.
          redirect_to  admins_quiz_path(quiz), :flash => { :error_messages => verbal_quiz_uploader.error_messages }
        end
        
      else
        # Invalid Excel
        redirect_to  admins_quiz_path(quiz), :flash => { :error_messages => verbal_quiz_uploader.error_messages }
      end
      
    end
    
    # Upload quant test excel
    def upload_quant_excel
      
      quiz = Quiz.find_by_slug!(params[:id])
      
      if params[:quiz][:dry_run] == "true"
        dry_run = true
      else
        dry_run = false
      end
      
      quant_quiz_uploader = QuantQuizUploader.new(getWorkbookFromParams(params),quiz,dry_run)
      
      if quant_quiz_uploader.validate_excel_workbook
        # Valid Excel
        
        if quant_quiz_uploader.execute_excel_upload
          # Excel upload executed successfully.
          #render :json => { :message => "Valid and uploaded correctly",:success => full_quiz_uploader.success_messages.to_s }
          redirect_to  admins_quiz_path(quiz), :flash => { :success_messages => quant_quiz_uploader.success_messages }
        else
          # Excel upload failed.
          redirect_to  admins_quiz_path(quiz), :flash => { :error_messages => quant_quiz_uploader.error_messages }
        end
        
      else
        # Invalid Excel
        redirect_to  admins_quiz_path(quiz), :flash => { :error_messages => quant_quiz_uploader.error_messages }
      end
      
    end
    
    # Upload multiple images associated with the quiz.
    def question_images_upload
      
      @quiz = Quiz.find_by_slug!(params[:id])
      
      begin
        quiz_question_images = params[:quiz][:quiz_question_images]
        quiz_question_images.each do |quiz_question_image|
          file = QuizQuestionImagesUploader.new
          file.quiz_id = @quiz.id
          file.store!(quiz_question_image)
        end
      rescue Exception => e
        redirect_to [:admins, @quiz], notice: "Image upload failed."
        return
      end
      
      redirect_to [:admins, @quiz], notice: "Images uploaded successfully."
      
    end
    
    def publish
      
      @quiz = Quiz.find_by_slug!(params[:id])
      @quiz.published = true
      @quiz.publisher_id = current_user.id
      @quiz.published_at = DateTime.now
      @quiz.save!
      
      redirect_to [:admins, @quiz], notice: "Quiz published successfully."
      
    end
    
    def unpublish
      
      @quiz = Quiz.find_by_slug!(params[:id])
      @quiz.published = false
      @quiz.publisher_id = current_user.id
      @quiz.published_at = DateTime.now
      @quiz.save!
      
      redirect_to [:admins, @quiz], notice: "Quiz unpublished successfully."
      
    end
    
    def approve
      
      @quiz = Quiz.find_by_slug!(params[:id])
      @quiz.approved = true
      @quiz.approver_id = current_user.id
      @quiz.approved_at = DateTime.now
      @quiz.save!
      
      redirect_to [:admins, @quiz], notice: "Quiz approved successfully."
      
    end
    
    def reject
      
      @quiz = Quiz.find_by_slug!(params[:id])
      @quiz.published = false
      @quiz.approver_id = current_user.id
      @quiz.approved_at = DateTime.now
      @quiz.save!
      
      redirect_to [:admins, @quiz], notice: "Quiz rejected successfully."
      
    end
    
    def unapprove
      
      @quiz = Quiz.find_by_slug!(params[:id])
      @quiz.approved = false
      @quiz.approver_id = current_user.id
      @quiz.approved_at = DateTime.now
      @quiz.save!
      
      redirect_to [:admins, @quiz], notice: "Quiz unapproved successfully."
      
    end
    
    # Action to delete all the images.
    def question_images_delete_all
      
      @quiz = Quiz.find_by_slug!(params[:id])
      
      begin
        uploader = QuizQuestionImagesUploader.new
        uploader.quiz_id = @quiz.id
        logger.info(uploader.delete_all_images)
      rescue Exception => e
        redirect_to [:admins, @quiz], notice: "Images could not be deleted."
        return    
      end
      
       redirect_to [:admins, @quiz], notice: "Images deleted successfully."
      
    end
    
    # Upload category test.
    def upload_excel
      
      logger.info("params = " + params.to_s)
      
      quiz = Quiz.find_by_slug!(params[:id])
      
      if params[:quiz][:dry_run] == "true"
        dry_run = true
      else
        dry_run = false
      end
      
      quiz_uploader = CategoryQuizUploader.new(getWorkbookFromParams(params),quiz,dry_run)
      
      if quiz_uploader.validate_excel_workbook
        # Valid Excel
        
        if quiz_uploader.execute_excel_upload
          # Excel upload executed successfully.
          redirect_to  admins_quiz_path(quiz), :flash => { :success_messages => quiz_uploader.success_messages }
        else
          # Excel upload failed.
          redirect_to  admins_quiz_path(quiz), :flash => { :error_messages => quiz_uploader.error_messages }
        end
        
      else
        # Invalid Excel
        redirect_to  admins_quiz_path(quiz), :flash => { :error_messages => quiz_uploader.error_messages }
      end
      
    end
    
    private
    
    # Return the workbook object from the uploaded file and
    # remove the file once the object is retrived.
    def getWorkbookFromParams(_params)
      quiz_file = _params[:quiz][:full_quiz_excel]
      file = FullQuizFileUploader.new
      file.quiz_id = _params[:id]
      file.store!(quiz_file)
      book = Spreadsheet.open Rails.root.join('tmp/uploads').join"#{file.store_path}"
      file.delete_file
      return book
    end
    
    def load_quiz
      @quiz = Quiz.find_by_slug!(params[:id])
    end
    
    def upload_excel_path
      if @quiz.quiz_type_id == QuizType.find_by_name("CategoryQuiz").id
        
        upload_path = upload_excel_admins_quiz_path(@quiz)
        
      elsif @quiz.quiz_type_id == QuizType.find_by_name("TopicQuiz").id
        if @quiz.topic.section_type.name == "Verbal"
          upload_path = upload_verbal_excel_admins_quiz_path(@quiz)
        else
          upload_path = upload_quant_excel_admins_quiz_path(@quiz)
        end
      elsif @quiz.quiz_type_id == QuizType.find_by_name("SectionQuiz").id
        if @quiz.section_type.name == "Verbal"
          upload_path = upload_verbal_excel_admins_quiz_path(@quiz)
        else
          upload_path = upload_quant_excel_admins_quiz_path(@quiz)
        end
      else
        upload_path = upload_full_excel_admins_quiz_path(@quiz)
      end
      upload_path
    end
    
  end
end