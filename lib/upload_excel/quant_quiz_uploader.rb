# Class to upload quant test excel.
module UploadExcel
  class QuantQuizUploader
    
    def initialize(_workbook,_quiz,_dry_run)
      
      # Hold messages to display.
      @success_messages = []
      @error_messages = []
      
      @quant_sheet = (_workbook.worksheet 0)
      
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
      
      return @upload_helper.quant_validate_excel_workbook
      
    end
    
    # Upload the excel file by inserting data into database.
    # 
    # return true is everything goes well.
    # return false if there us any error.
    def execute_excel_upload
      
      clear_quiz
      
      @verbal_section, @questions, @options = @upload_helper.process_quant_sheet(@quant_sheet,@quiz,1)
      
      if !@dry_run
        # Save the objects stored in the array.
        if !save_objects_to_db
         @error_messages << "Saving objects to db failed"
         return false
        end
      end
      
      @success_messages << ("1 section uploaded.")
      @success_messages << ("section 1 #{@questions.count.to_s} Questions uploaded")
      
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
      
      if !@quant_section.save
        roll_back_created_objects
        return false
      end
      
      @questions.each_with_index do |question,question_index|
        
        question.section_id = @quant_section.id
        
        if !question.save
          roll_back_created_objects
          return false
        end
      
        @options[question_index].each_with_index do |option,option_index|
          
          option.question_id = question.id
          
          if !option.save
            roll_back_created_objects(section_index)
            return false
          end
            
        end
        
      end
      
      return true
    end
    
    # Roll-back the entire section
    def roll_back_created_objects
        section.destroy
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