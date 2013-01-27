# Class to upload verbal test excel.
module UploadExcel
  class VerbalQuizUploader
    
    def initialize(_workbook,_quiz)
      
      # Fetch worksheets.
      @sheets = []
      @sheets << (_workbook.worksheet 0)
      @sheets << (_workbook.worksheet 1)
      
      # Hold messages to display.
      @success_messages = []
      @error_messages = []
      
      # Hold the section objects that need to be saved to db.
      # Question & Option objects will be saved under the section object.
      @sections = []
      @questions = [[]]
      @options = [[[]]]
      
      @verbal_sheet = @sheets[0]
      @curr_question_index = 0
      
      # Hold the current quiz object
      @quiz = _quiz
      
    end
    
    # Check if the excel file has the minimum required format. Further validation 
    # will be carried out when processing the file.
    #
    # Criteria 1: There should be 2 sheets.
    # Criteria 2: DATA should be in the 2nd sheet.
    # Criteria 3: Check if correct column names exist for the sheet.
    # Criteria 4: Check if there are question # 1 - 20 on each sheet.
    # Criteria 5: Check if Type column has valid entries & matching option set.
    def validate_excel_workbook
      
      # Criteria 1
      if !workbook_has_2_sheets?
        return false
      end
      
      # Criteria 2
      if !workbook_has_2nd_data_sheet?
        return false
      end
      
      # Criteria 3
      if !are_sheet_colums_valid?
        return false
      end
      
      # Criteria 4
      if !are_que_numbers_correct?
        return false
      end
      
      # Criteria 5
      if !are_que_types_and_optionsets_valid?
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
      @success_messages << "Quiz uploaded successfully."
      
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
    
    # Criteria 1: There should be 2 sheets
    def workbook_has_2_sheets?
      
      if ( @sheets[0] == nil || @sheets[1] == nil)
        @error_messages << "Should have only 2 sheets."
        return false 
      end
      
      return true
      
    end
    
    # Criteria 2: DATA should be in the 2nd sheet.
    def workbook_has_2nd_data_sheet?
      if (@sheets[1].name != "DATA")
        @error_messages << "Last data sheet should be DATA."
        return false
      end
      
      return true
    end
    
    # Criteria 3: Check if correct column names exist for the verbal sheet.
    def are_sheet_colums_valid?
      
      (0..17).each do |i|

        correct_name = case
                       when i == 0 then "No"
                       when i == 1 then "Type"
                       when i == 2 then "HeaderInstruction"
                       when i == 3 then "Passage"
                       when i == 4 then "QueText"
                       when i == 5 then "SolText"
                       when i == 6 then "OptionSets"
                       when i == 7 then "Correct"
                       when i == 8 then "Option1"
                       when i == 9 then "Option2"
                       when i == 10 then "Option3"
                       when i == 11 then "Option4"
                       when i == 12 then "Option5"
                       when i == 13 then "Option6"
                       when i == 14 then "Option7"
                       when i == 15 then "Option8"
                       when i == 16 then "Option9"
                       when i == 17 then "Option10"    
                       end
                       
        if @verbal_sheet.row(0).at(i).to_s != correct_name
          @error_messages << ("Sheet => #{@verbal_sheet.name},Incorrect Column # #{(i+1).to_s} => #{@verbal_sheet.row(0).at(i).to_s},Required Column => #{correct_name}")
          return false
        end            

      end

      return true
      
    end
    
    # Criteria 4: Check if there are question # 1 - 20 on each sheet.
    def are_que_numbers_correct?
      
      # TODO: Return false if a invalid entry found.
      
      return true
    end
    
    # Criteria 5: Check if Type column has valid entries & matching option set.
    def are_que_types_and_optionsets_valid?
      
      # TODO: Return false if a invalid entry found.
      
      return true
    end
    
  end
end