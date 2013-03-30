# Class to upload students.
module UploadExcel
  class StudentsUploader
    
    attr_reader :students
    
    def initialize(_workbook,dry_run)
      
      # Fetch worksheets.
      @sheet = (_workbook.worksheet 0)
      
      # Hold messages to display.
      @success_messages = []
      @error_messages = []
     
			@dry_run = dry_run
 
      # Hold the student objects that need to be saved to db.
      @students = []
      
    end
    
    # Check if the excel file has the minimum required format. Further validation 
    # will be carried out when processing the file.
    #
    # Criteria 1: First sheet should be named "Students"
    # Criteria 2: Should contain 3 columns. [ "Full Name", "Email" & "Credits" ]
    def validate_excel_workbook
      
      # Criteria 1
      # if !workbook_has_1_sheet?
      #  return false
      # end
      
      # Criteria 2
      if !worksheet_has_3_columns?
        return false
      end

			# Criteria 3
			if !worksheet_has_valid_students_and_does_end?
				return false
			end
      
      ## Enter future validation criterias here ##
      
      Rails.logger.info("VALIDATION PASSED")
      
      return true
      
    end
    
    # Upload the excel file by inserting data into database.
    # 
    # return true is everything goes well.
    # return false if there us any error.
    def execute_excel_upload
     
			if !@dry_run 
       # Iterate through all students and save them.
       @students.each_with_index do |student,index|
  	     if !student.save
				   @error_messages << "Failed to save student with email:" + student.email
					 roll_back_created_students(index)
				   return false
				 end 
       end
      end

      return true
      
    end
    
    # Getters
    def error_messages
      @error_messages
    end
    
    def success_messages
      @success_messages
    end
    
    private
    
    # Criteria 1: First sheet should be named "Students"
    def workbook_has_1_sheet?
      
      if ( @sheet.name != "Students" )
        @error_messages << "First sheet needs to be name 'Students'"
        return false
      end
      
      return true
      
    end
    
    # Criteria 2: Should contain 3 columns. [ "Full Name", "Email" & "Credits" ]
    def worksheet_has_3_columns?
      
      if @sheet.row(0).at(0).to_s != "Full Name" ||
         @sheet.row(0).at(1).to_s != "Email" ||
         @sheet.row(0).at(2).to_s != "Password"
        
         @error_messages << "Should contain 3 columns. [ 'Full Name', 'Email' & 'Password' ]."
         return false
         
      end
      
      return true
    end
  	
    # Criteria 3: Should have a "$$" sign in the first column to indicate end of file. 
    def worksheet_has_valid_students_and_does_end?
      
			0.upto @worksheet.last_row_index do |index|
  			# Get current row
  			row = @worksheet.row(index)
			 
 				full_name = row[0].to_s.strip	
				if full_name == "" || full_name == "##"
					return true
				end

  			student = User.new
  			student.full_name = full_name
  			student.email = row[1].to_s.strip
				student.password = row[2].to_s.strip
				student.password_confirmation = row[2].to_s.strip
				
				if !student.valid?
          @error_messages << "Invaid user [row: #{index.to_s}, email: #{student.email.to_s}, reason: #{student.errors.full_messages.to_s}]"
					return false
				end

				@students << student
			end
      
      return false
    end
		
		def roll_back_created_students(index)
			(0...index).each do |i|
				@students[i].destroy
			end
		end 
    
  end
end
