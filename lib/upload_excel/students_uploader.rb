# Class to upload students.
module UploadExcel
  class StudentsUploader
    
    attr_reader :students
    
    def initialize(_workbook)
      
      # Fetch worksheets.
      @sheet = (_workbook.worksheet 0)
      
      # Hold messages to display.
      @success_messages = []
      @error_messages = []
      
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
      if !workbook_has_1_sheet?
        return false
      end
      
      # Criteria 2
      if !worksheet_has_3_columns?
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
      
      # Iterate through first 50 records only.
      # Limit to be increased later if required.
      (1..50).each do |row_index|
        
        # Current row.
        row = @sheet.row(row_index)
        
        # Fetch values for the row.
        full_name = row[0].to_s.strip
        email = row[1].to_s.strip
        credits = row[2].to_i
        
        if full_name == "" || email == ""
          break
        else
          @students << User.new(:full_name => full_name, :email => email, :credits => credits)
        end
        
      end
      
      if !validate_user_models?
        return false
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
         @sheet.row(0).at(2).to_s != "Credits"
        
         @error_messages << "Should contain 3 columns. [ 'Full Name', 'Email' & 'Credits' ]."
         return false
         
      end
      
      return true
    end
    
    def validate_user_models?
      
      @students.each_with_index do |student,index|
        
        if !student.valid?
          @error_messages << "Error creating user [row: #{index.to_s}, email: #{student.email.to_s}, reason: #{student.errors.full_messages.to_s}]"
          return false
        end
        
      end
      
    end
    
  end
end