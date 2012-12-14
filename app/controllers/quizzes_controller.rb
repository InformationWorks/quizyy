class QuizzesController < ApplicationController
  
  include UploadExcel
  
  # GET /quizzes
  # GET /quizzes.json
  def index
    @quizzes = Quiz.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quizzes }
    end
  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show
    @quiz = Quiz.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quiz }
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
    @quiz = Quiz.find(params[:id])
  end

  # POST /quizzes
  # POST /quizzes.json
  def create
    @quiz = Quiz.new(params[:quiz])

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
    @quiz = Quiz.find(params[:id])

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
    @quiz = Quiz.find(params[:id])
    @quiz.destroy

    respond_to do |format|
      format.html { redirect_to quizzes_url }
      format.json { head :no_content }
    end
  end
  
  # Upload full legth test excel
  def upload_full_excel
    
    full_quiz_uploader = FullQuizUploader.new(getWorkbookFromParams(params))
    
    if full_quiz_uploader.validate_excel_workbook
      # Valid Excel
      
      if full_quiz_uploader.execute_excel_upload
        # Excel upload executed successfullly.
        render :json => { :message => "Valid" }  
      else
        # Excel upload failed.
        render :json => { :message => "InValid",:error => full_quiz_uploader.error_messages.to_s }
      end
      
    else
      # Invalid Excel
      render :json => { :message => "InValid",:error => full_quiz_uploader.error_messages.to_s }
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
  
end
