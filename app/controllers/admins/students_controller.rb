module Admins
  class StudentsController < AdminsController
    
    include UploadExcel
    
    def new
      @student = User.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @quiz_type }
      end
    end
    
    def create
      @student = User.new(params[:user])
      @student.credits = params[:credits_to_add]
      @student.roles << Role.find_by_name("Student")
  
      respond_to do |format|
        if @student.save
          
          # Log the "AddCredit" activity in ActivityLog.
          ActivityLog.create(:actor_id => current_user.id,
                              :action => "AddCredit",
                              :target_id => @student.id,
                              :activity => "added #{params[:credits_to_add]} to #{@student.full_name}'s new account.",
                              :desc => "New student creation")
          
          format.html { redirect_to admins_students_path, notice: 'Student created successfully.' }
          format.json { render json: @student, status: :created, location: @student }
        else
          format.html { render action: "new" }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def index
      @students = Role.find_by_name("Student").users
    end
    
    def upload_via_excel
      
      students_uploader = StudentsUploader.new(getWorkbookFromParams(params))
      
      if students_uploader.validate_excel_workbook
        # Valid Excel
        if students_uploader.execute_excel_upload
          # Students array populated with user models.
          # Valid? returned true for each model in execute_excel_upload.
          students = students_uploader.students
          if students != nil && students != []
            students.each do |student|
              student.roles << Role.find_by_name("Student")
              student.save!
            end
            redirect_to admins_students_path, notice: "Students created successfully."
          else
            redirect_to admins_students_path, notice: "Error creating students."
          end
        else
          redirect_to admins_students_path, notice: "Error uploading users. Error = " + students_uploader.error_messages.to_s
        end
        
      else
        # Invalid Excel
        render :json => { :message => "InValid",:error => students_uploader.error_messages.to_s }
      end
      
    end
   
    private
    
      # Return the workbook object from the uploaded file and
      # remove the file once the object is retrived.
      def getWorkbookFromParams(_params)
        quiz_file = _params[:students_excel]
        file = FullQuizFileUploader.new
        file.quiz_id = _params[:id]
        file.store!(quiz_file)
        book = Spreadsheet.open Rails.root.join('tmp/uploads').join"#{file.store_path}"
        file.delete_file
        return book
      end
    
  end
end