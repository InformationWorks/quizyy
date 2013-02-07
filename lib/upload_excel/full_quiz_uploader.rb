# Class to upload full test excel.
module UploadExcel
  class FullQuizUploader
    
    def initialize(_workbook,_quiz,_dry_run)
      
      # Fetch worksheets.
      @sheets = []
      @sheets << (_workbook.worksheet 0)
      @sheets << (_workbook.worksheet 1)
      @sheets << (_workbook.worksheet 2)
      @sheets << (_workbook.worksheet 3)
      @sheets << (_workbook.worksheet 4)
      
      # Hold messages to display.
      @success_messages = []
      @error_messages = []
      
      # Hold the section objects that need to be saved to db.
      # Question & Option objects will be saved under the section object.
      @sections = []
      @questions = [[]]
      @options = [[[]]]
      
      # Current sheet variable to keep track of what sheet is currently being handled.
      @curr_sheet_index = 0  
      @curr_sheet = @sheets[0]
      @curr_question_index = 0
      
      # Hold the current quiz object
      @quiz = _quiz
      
      # Set dry_run
      @dry_run = _dry_run
      
      # Use upload_helper for processing.
      @upload_helper = UploadHelper.new(@error_messages,@success_messages,_workbook)
      
    end
    
    # Check if the excel file has the minimum required format. Further validation 
    # will be carried out when processing the file.
    def validate_excel_workbook
      
      return @upload_helper.validate_full_excel_workbook
      
    end
    
    # Upload the excel file by inserting data into database.
    # 
    # return true is everything goes well.
    # return false if there us any error.
    def execute_excel_upload
      
      clear_quiz
      
      # process each sheet.
      (0..3).each do | sheet_index |
        
        @curr_sheet_index = sheet_index
        @curr_sheet = @sheets[sheet_index]
        
        Rails.logger.info("Processing Sheet # = " + sheet_index.to_s + " name = " + @curr_sheet.name)
        
        if ((@curr_sheet.name == "VERBAL-1") || (@curr_sheet.name  == "VERBAL-2"))
        
          verbal_section, questions, options = @upload_helper.process_verbal_sheet(@curr_sheet,@quiz,@curr_sheet_index+1)
        
          @sections << verbal_section
          @questions[@curr_sheet_index] = questions
          
          @options[@curr_sheet_index] = []
          questions.each_with_index  do |question,index|
            @options[@curr_sheet_index][index] = options[index]
          end
        
        elsif ((@curr_sheet.name == "QUANT-1") || (@curr_sheet.name  == "QUANT-2"))
        
          quant_section, questions, options = @upload_helper.process_quant_sheet(@curr_sheet,@quiz,@curr_sheet_index+1)
        
          @sections << quant_section
          @questions[@curr_sheet_index] = questions
          
          @options[@curr_sheet_index] = []
          questions.each_with_index  do |question,index|
            @options[@curr_sheet_index][index] = options[index]
          end
        
        end 
        
      end
      
      if !@dry_run
        # Save the objects stored in the array.
        if !save_objects_to_db
         @error_messages << "Saving objects to db failed"
         return false
        end
      end
      
      @success_messages << ("#{@sections.count.to_s} sections uploaded.")
      @success_messages << ("section 1 #{@questions[0].count.to_s} Questions uploaded")
      @success_messages << ("section 2 #{@questions[1].count.to_s} Questions uploaded")
      @success_messages << ("section 3 #{@questions[2].count.to_s} Questions uploaded")
      @success_messages << ("section 4 #{@questions[3].count.to_s} Questions uploaded")
      @success_messages << "All Sections, Questions & Options saved successfully."
      
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
    
    # Save all the objects to db.
    # Roll back if any of the object fails to save.
    def save_objects_to_db
      
      @sections.each_with_index do |section,section_index|
        
        if !section.save
          roll_back_created_objects(section_index)
          return false
        end
        
        @questions[section_index].each_with_index do |question,question_index|
          
          question.section_id = section.id
          
          if !question.save
            roll_back_created_objects(section_index)
            return false
          end
        
          @options[section_index][question_index].each_with_index do |option,option_index|
            
            option.question_id = question.id
            
            if !option.save
              roll_back_created_objects(section_index)
              return false
            end
              
          end
          
        end
        
      end
      
      return true
    end
    
    # Roll-back using the section_index that caused the error.
    def roll_back_created_objects(section_index)
      (1..section_index).each do |section|
        section.destroy
      end
    end
    
    # Delete all the sections, questions & options before uploading.
    def clear_quiz
      
      # Section -> Question -> Option [ Dependent destroy ] 
      @quiz.sections.each do |section|
        section.destroy
      end
      
    end
    
  end
end