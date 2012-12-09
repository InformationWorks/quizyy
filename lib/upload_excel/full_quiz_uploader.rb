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
    def validate_excel_workbook
      
      Rails.logger.info("Here")
      
      # Criteria 1
      if ( @sheet1 == nil || @sheet2 == nil || @sheet3 == nil || @sheet4 == nil || @sheet5 == nil )
        @error_messages << "Minimum 5 sheets required."
        return false 
      end
      
      # Criteria 2
      sheet_names = [] << @sheet1.name << @sheet2.name << @sheet3.name << @sheet4.name
      
      if ((sheet_names & [ "VERBAL-1", "VERBAL-2", "QUANT-1", "QUANT-2" ]).count != 4)
        @error_messages << "First 4 sheets should contain all of : VERBAL-1, VERBAL-2, QUANT-1 and QUANT-2."
        return false
      end
      
      # Criteria 3
      if (@sheet5.name != "DATA")
        @error_messages << "Last data sheet should be DATA."
        return false
      end
      
      # TODO: Criteria 4
      
      # TODO: Criteria 5
      
      
      return true
      
    end
    
    # Getters
    def error_messages
      @error_messages
    end
    
    def success_messages
      @success_messages
    end
    
  end
end