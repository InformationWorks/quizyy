# Class to upload full test excel.
module UploadExcel
  class FullQuizUploader
    
    def initialize(workbook)
      
      # Fetch worksheets.
      @sheet1 = workbook.worksheet 0
      @sheet2 = workbook.worksheet 1
      @sheet3 = workbook.worksheet 2
      @sheet4 = workbook.worksheet 3
      @sheet5 = workbook.worksheet 4
      
      @success_messages = []
      @error_messages = []
    end
    
    # Check if the excel file has the minimum required format. Further validation 
    # will be carried out when processing the file.
    #
    # Criteria 1: There should be minimum 5 sheets
    # Criteria 2: First 4 sheets should contain all of - "VERBAL-1","VERBAL-2","QUANT-1" and "QUANT-1".
    # Criteria 3: DATA should be the last sheet.
    # Criteria 4: Check if correct column names exist for the sheets.
    # Criteria 5: Check if there are question # 1 - 20 on each sheet.
    # Criteria 6: Check if Type column has valid entries & matching option set.
    def validate_excel_workbook
      
      # Criteria 1
      if !workbook_has_5_sheets?
        return false
      end
      
      # Criteria 2
      if !workbook_has_4_correct_sheets?
        return false
      end
      
      # Criteria 3
      if !workbook_has_5th_data_sheet?
        return false
      end
      
      # Criteria 4
      if !are_sheet_colums_valid?
        return false
      end
      
      # Criteria 5
      if !are_que_numbers_correct?
        return false
      end
      
      # Criteria 6
      if !are_que_types_and_optionsets_valid?
        return false
      end
      
      ## Enter future validation criterias here ##
      
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
    
    # Criteria 1: There should be minimum 5 sheets
    def workbook_has_5_sheets?
      
      if ( @sheet1 == nil || @sheet2 == nil || @sheet3 == nil || @sheet4 == nil || @sheet5 == nil )
        @error_messages << "Minimum 5 sheets required."
        return false 
      end
      
      return true
      
    end
    
    # Criteria 2: First 4 sheets should contain all of - "VERBAL-1","VERBAL-2","QUANT-1" and "QUANT-1".
    def workbook_has_4_correct_sheets?
      sheet_names = [] << @sheet1.name << @sheet2.name << @sheet3.name << @sheet4.name
      
      if ((sheet_names & [ "VERBAL-1", "VERBAL-2", "QUANT-1", "QUANT-2" ]).count != 4)
        @error_messages << "First 4 sheets should contain all of : VERBAL-1, VERBAL-2, QUANT-1 and QUANT-2."
        return false
      end
      
      return true
    end
      
    # Criteria 3: DATA should be the last sheet.
    def workbook_has_5th_data_sheet?
      if (@sheet5.name != "DATA")
        @error_messages << "Last data sheet should be DATA."
        return false
      end
      
      return true
    end
    
    # Criteria 4: Check if correct column names exist for the sheets.
    def are_sheet_colums_valid?
      
      [@sheet1,@sheet2,@sheet3,@sheet4].each do | sheet |
          
        if ( sheet.name == "VERBAL-1" || sheet.name == "VERBAL-2" )
          
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
                           
            if sheet.row(0).at(i).to_s != correct_name
              @error_messages << ("Sheet => #{sheet.name},Incorrect Column # #{(i+1).to_s} => #{sheet.row(0).at(i).to_s},Required Column => #{correct_name}")
              return false
            end            

          end
        
        elsif ( sheet.name == "QUANT-1" || sheet.name == "QUANT-2" )
          
          (0..23).each do |i|
            
            correct_name = case
                           when i == 0 then "No"
                           when i == 1 then "Type"
                           when i == 2 then "DILocation"
                           when i == 3 then "Topic"
                           when i == 4 then "HeaderInstruction"
                           when i == 5 then "Passage"
                           when i == 6 then "QueText"
                           when i == 7 then "QueImage"
                           when i == 8 then "SolText"
                           when i == 9 then "SolImage"
                           when i == 10 then "Quantity-A"
                           when i == 11 then "Quantity-B"                            
                           when i == 12 then "Options"
                           when i == 13 then "Correct"
                           when i == 14 then "Option1"
                           when i == 15 then "Option2"
                           when i == 16 then "Option3"
                           when i == 17 then "Option4"
                           when i == 18 then "Option5"
                           when i == 19 then "Option6"
                           when i == 20 then "Option7"
                           when i == 21 then "Option8"
                           when i == 22 then "Option9"
                           when i == 23 then "Option10"    
                           end
                           
            if sheet.row(0).at(i).to_s != correct_name
              @error_messages << ("Sheet => #{sheet.name},Incorrect Column # #{(i+1).to_s} => #{sheet.row(0).at(i).to_s},Required Column => #{correct_name}")
              return false
            end            

          end

        end
        
      end

      return true
      
    end
    
    # Criteria 5: Check if there are question # 1 - 20 on each sheet.
    def are_que_numbers_correct?
      
      # TODO: Return false if a invalid entry found.
      
      return true
    end
    
    # Criteria 6: Check if Type column has valid entries & matching option set.
    def are_que_types_and_optionsets_valid?
      
      # TODO: Return false if a invalid entry found.
      
      return true
    end
    
  end
end