module Admins
  class StudentsController < AdminsController
    
    before_filter :authenticate_user!
    before_filter :check_authorization
    before_filter :check_manage_authorization, :only => [:delete, :reconfirm, :confirm]
    include UploadExcel
    
    def new
      @student = User.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @quiz_type }
      end
    end
    
    def edit
      @student = User.find(params[:id]) 
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
			@users = User.non_students
      @students = User.students
    end
    
    def upload_via_excel
       
		  logger.info("dry run = #{params[:dry_run]}")	

			if params[:dry_run] == "true"
        dry_run = true
      else
        dry_run = false
      end
 
      students_uploader = StudentsUploader.new(getWorkbookFromParams(params),dry_run)

      if students_uploader.validate_excel_workbook
        # Valid Excel
        if students_uploader.execute_excel_upload
          # Excel upload executed successfully.
					redirect_to admins_students_path, :flash => { :success_messages => students_uploader.success_messages }       
				else
					# Excel upoload failed.
					redirect_to admins_students_path, :flash => { :error_messages => students_uploader.error_messages }
        end
        
      else
        # Invalid Excel
        redirect_to admins_students_path, :flash => { :error_messages => students_uploader.error_messages }
			end
      
    end
    
    def reconfirm
      
      user = User.find(params[:user_id])
      
      if user.confirmed?
        redirect_to admins_students_path, notice: "User already confirmed." 
      else
        user.send_confirmation_instructions
        redirect_to admins_students_path, notice: "Confirmation instruction sent to #{user.full_name}."
      end
      
    end
    
    def confirm
      
      user = User.find(params[:user_id])
      
      if user.confirmed?
        redirect_to admins_students_path, notice: "User already confirmed." 
      elsif user.confirm!
        redirect_to admins_students_path, notice: "User confirmed successfully." 
      else
        redirect_to admins_students_path, notice: "User could not be confirmed."
      end
      
    end
    
    def delete
      
      user = User.find(params[:user_id])
      
      if user.delete
        redirect_to admins_students_path, notice: "User deleted successfully" 
      else
        redirect_to admins_students_path, notice: "User coult not be deleted"
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
      
      def check_authorization
        authorize! :create, :students
      end
      
      def check_manage_authorization
        authorize! :manage, :students
      end
        
    
  end
end
