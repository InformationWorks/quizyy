class QuizzesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :load_quiz, :only => [ :show, :edit, :update, :destroy ]
  load_and_authorize_resource :find_by => :slug
  
  include UploadExcel
  
  # GET /quizzes
  # GET /quizzes.json
  def index
    
    @quizzes = Quiz.all
    @full_quizzes = Quiz.where(:quiz_type_id => QuizType.find_by_name("FullQuiz"))
    @category_quizzes = Quiz.where(:quiz_type_id => QuizType.find_by_name("CategoryQuiz"))
    @topic_quizzes = Quiz.where(:quiz_type_id => QuizType.find_by_name("TopicQuiz"))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quizzes }
    end
  end

  # GET /quizzes/1
  def show
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
    end

    respond_to do |format|
      if @quiz.save
        format.html { redirect_to @quiz, notice: 'Quiz was successfully created.' }
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
    end

    respond_to do |format|
      if @quiz.update_attributes(params[:quiz])
        format.html { redirect_to @quiz, notice: 'Quiz was successfully updated.' }
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
      format.html { redirect_to quizzes_url, notice: 'Quiz was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  
  # Upload full legth test excel
  def upload_full_excel
    
    quiz = Quiz.find_by_slug!(params[:id])
    
    full_quiz_uploader = FullQuizUploader.new(getWorkbookFromParams(params),quiz)
    
    if full_quiz_uploader.validate_excel_workbook
      # Valid Excel
      
      if full_quiz_uploader.execute_excel_upload
        # Excel upload executed successfully.
        #render :json => { :message => "Valid and uploaded correctly",:success => full_quiz_uploader.success_messages.to_s }
        redirect_to  quiz_path(quiz), :flash => { :success_messages => full_quiz_uploader.success_messages }
      else
        # Excel upload failed.
        redirect_to  quiz_path(quiz), :flash => { :error_messages => full_quiz_uploader.error_messages }
      end
      
    else
      # Invalid Excel
      render :json => { :message => "InValid",:error => full_quiz_uploader.error_messages.to_s }
    end
    
  end
  
  # Upload multiple images associated with the quiz.
  def question_images_upload
    
    @quiz = Quiz.find_by_slug!(params[:quiz_id])
    
    begin
      quiz_question_images = params[:quiz][:quiz_question_images]
      quiz_question_images.each do |quiz_question_image|
        file = QuizQuestionImagesUploader.new
        file.quiz_id = params[:quiz_id]
        file.store!(quiz_question_image)
      end
    rescue Exception => e
      redirect_to @quiz, notice: "Image upload failed."
      return
    end
    
    redirect_to @quiz, notice: "Images uploaded successfully."
    
  end
  
  def publish
    
    @quiz = Quiz.find_by_slug!(params[:quiz_id])
    @quiz.published = true
    @quiz.publisher_id = current_user.id
    @quiz.published_at = DateTime.now
    @quiz.save!
    
    redirect_to @quiz, notice: "Quiz published successfully."
    
  end
  
  def unpublish
    
    @quiz = Quiz.find_by_slug!(params[:quiz_id])
    @quiz.published = false
    @quiz.publisher_id = current_user.id
    @quiz.published_at = DateTime.now
    @quiz.save!
    
    redirect_to @quiz, notice: "Quiz unpublished successfully."
    
  end
  
  def approve
    
    @quiz = Quiz.find_by_slug!(params[:quiz_id])
    @quiz.approved = true
    @quiz.approver_id = current_user.id
    @quiz.approved_at = DateTime.now
    @quiz.save!
    
    redirect_to @quiz, notice: "Quiz approved successfully."
    
  end
  
  def reject
    
    @quiz = Quiz.find_by_slug!(params[:quiz_id])
    @quiz.published = false
    @quiz.approver_id = current_user.id
    @quiz.approved_at = DateTime.now
    @quiz.save!
    
    redirect_to @quiz, notice: "Quiz rejected successfully."
    
  end
  
  def unapprove
    
    @quiz = Quiz.find_by_slug!(params[:quiz_id])
    @quiz.approved = false
    @quiz.approver_id = current_user.id
    @quiz.approved_at = DateTime.now
    @quiz.save!
    
    redirect_to @quiz, notice: "Quiz unapproved successfully."
    
  end
  
  # Action to delete all the images.
  def question_images_delete_all
    
    @quiz = Quiz.find_by_slug!(params[:quiz_id])
    
    begin
      uploader = QuizQuestionImagesUploader.new
      uploader.quiz_id = params[:quiz_id]
      logger.info(uploader.delete_all_images)
    rescue Exception => e
      redirect_to @quiz, notice: "Images could not be deleted."
      return    
    end
    
     redirect_to @quiz, notice: "Images deleted successfully."
    
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
  
end
