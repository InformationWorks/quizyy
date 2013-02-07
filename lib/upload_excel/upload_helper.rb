# Class to hold common code for all quiz uploaders.
module UploadExcel
  class UploadHelper
    
    def initialize(error_messages,success_messages,workbook)
        @error_messages = error_messages
        @success_messages = success_messages
        @workbook = workbook
    end 
    
    #############################################################################
    #############################################################################
    #--------------------------- VERBAL HELPERS---------------------------------#
    #############################################################################
    #############################################################################
    
    # Check if the excel file has the minimum required format. Further validation 
    # will be carried out when processing the file.
    #
    # Criteria 1: There should be 2 sheets.
    # Criteria 2: DATA should be in the 2nd sheet.
    # Criteria 3: Check if correct column names exist for the sheet.
    # Criteria 4: Check if there are question # 1 - 20 on each sheet.
    # Criteria 5: Check if Type column has valid entries & matching option set.
    def verbal_validate_excel_workbook
      
      # Criteria 1
      if !workbook_has_2_sheets?
        return false
      end
      
      # Criteria 2
      if !workbook_has_2nd_data_sheet?
        return false
      end
      
      # Criteria 3
      if !are_verbal_sheet_colums_valid?
        return false
      end
      
      # Criteria 4
      if !are_que_numbers_correct?
        return false
      end
      
      # Criteria 5
      if !are_verbal_que_types_and_optionsets_valid?
        return false
      end
      
      ## Enter future validation criterias here ##
      
      Rails.logger.info("VALIDATION PASSED")
      
      return true
      
    end
    
    # Process a verbal sheet.
    # return true is processing is successful.
    # return false for unexpected results.
    def process_verbal_sheet(verbal_sheet,quiz)
      
      Rails.logger.info("IN create_verbal_questions")
      
      verbal_section = nil
      questions = []
      options = [[]]
    
      # Create the verbal section
      verbal_section = Section.new :name => verbal_sheet.name, 
                                   :sequence_no => 1, 
                                   :section_type_id => SectionType.find_by_name("Verbal").id
      verbal_section.quiz = quiz
      
      # Create questions under the created section
      create_verbal_questions(verbal_sheet,verbal_section,questions,options)
        
      return verbal_section,questions,options
    end
    
    #############################################################################
    #############################################################################
    #--------------------------- QUANT HELPERS----------------------------------#
    #############################################################################
    #############################################################################
    
    # Check if the excel file has the minimum required format. Further validation 
    # will be carried out when processing the file.
    #
    # Criteria 1: There should be 2 sheets.
    # Criteria 2: DATA should be in the 2nd sheet.
    # Criteria 3: Check if correct column names exist for the sheet.
    # Criteria 4: Check if there are question # 1 - 20 on each sheet.
    # Criteria 5: Check if Type column has valid entries & matching option set.
    def quant_validate_excel_workbook
      
      # Criteria 1
      if !workbook_has_2_sheets?
        return false
      end
      
      # Criteria 2
      if !workbook_has_2nd_data_sheet?
        return false
      end
      
      # Criteria 3
      if !are_quant_sheet_colums_valid?
        return false
      end
      
      # Criteria 4
      if !are_que_numbers_correct?
        return false
      end
      
      # Criteria 5
      if !are_quant_que_types_and_optionsets_valid?
        return false
      end
      
      ## Enter future validation criterias here ##
      
      Rails.logger.info("VALIDATION PASSED")
      
      return true
      
    end
    
    # Process a quant sheet.
    # return true is processing is successful.
    # return false for unexpected results.
    def process_quant_sheet(quant_sheet,quiz)
      
      Rails.logger.info("IN create_verbal_questions")
      
      quant_section = nil
      questions = []
      options = [[]]
      
      # Create the quant section
      quant_section = Section.new :name => quant_sheet.name, 
                                   :sequence_no => 1, 
                                   :section_type_id => SectionType.find_by_name("Quant").id
      quant_section.quiz = quiz
      
      # Create questions under the created section
      create_quant_questions(quant_sheet,quant_section,questions,options)
        
      return quant_section,questions,options
    end
    
    private
    
    #############################################################################
    #############################################################################
    #----------------------- COMMON PRIVATES HELPERS----------------------------#
    #############################################################################
    #############################################################################
    
    # Criteria 1: There should be 2 sheets
    def workbook_has_2_sheets?
      
      if ((@workbook.worksheet 0) == nil || (@workbook.worksheet 1) == nil)
        @error_messages << "Invalid Excel" << "Should have only 2 sheets."
        return false 
      end
      
      return true
      
    end
    
    # Criteria 2: DATA should be in the 2nd sheet.
    def workbook_has_2nd_data_sheet?
      if ((@workbook.worksheet 1).name != "DATA")
        @error_messages << "Invalid Excel" << "Last data sheet should be DATA."
        return false
      end
      
      return true
    end
    
    # Criteria 4: Check if there are question # 1 - 20 on each sheet.
    def are_que_numbers_correct?
      
      # TODO: Return false if a invalid entry found.
      
      return true
    end
    
    #############################################################################
    #############################################################################
    #----------------------- VERBAL PRIVATES HELPERS----------------------------#
    #############################################################################
    #############################################################################
    
    # Criteria 3: Check if correct column names exist for the verbal sheet.
    def are_verbal_sheet_colums_valid?
      
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
                       
        if (@workbook.worksheet 0).row(0).at(i).to_s != correct_name
          @error_messages << "Invalid Excel" << ("Sheet => #{(@workbook.worksheet 0).name},Incorrect Column # #{(i+1).to_s} => #{(@workbook.worksheet 0).row(0).at(i).to_s},Required Column => #{correct_name}")
          return false
        end            

      end

      return true
      
    end
    
    # Criteria 5: Check if Type column has valid entries & matching option set.
    def are_verbal_que_types_and_optionsets_valid?
      
      # TODO: Return false if a invalid entry found.
      
      return true
    end
    
    # Create question objects by reading each row of the current sheet.
    # Add questions to the section object.
    def create_verbal_questions(verbal_sheet,verbal_section,questions,options)
      Rails.logger.info("IN create_verbal_questions")
      # Start from row at index 1
      (1..20).each do |row_index|
        
        # Get current question and add it to the section.
        curr_que = getVerbalQuestionFromRow(verbal_sheet,verbal_section,questions,options,row_index)
        
        questions << curr_que
        
      end
        
    end
    
    # Generate a question object by reading a row from excel.
    # Also add option objects to the question object.
    def getVerbalQuestionFromRow(verbal_sheet,verbal_section,questions,options,row_index)
      
      row = verbal_sheet.row(row_index)
      
      question = Question.new
      
      begin
        
        sequence_no = row[0].to_s.strip
        question.sequence_no = (sequence_no == "") ? nil : sequence_no.to_i
        
        instruction = row[2].to_s.strip
        question.instruction = (instruction == "") ? nil : instruction
        
        passage = row[3].to_s.strip
        question.passage = (passage == "") ? nil : passage
        
        que_text = row[4].to_s.strip
        question.que_text = (que_text == "") ? nil : que_text
        
        sol_text = row[5].to_s.strip
        question.sol_text = (sol_text == "") ? nil : sol_text
        
        option_set_count = row[6].to_s.strip
        question.option_set_count = (option_set_count == "") ? nil : row[6].to_i        

        question.que_image = nil
        question.sol_image = nil
        question.di_location = nil
        question.quantity_a = nil
        question.quantity_b = nil
        
        # Question references.
        question.type = Type.find_by_code(row[1].to_s)
        question.topic = nil
        
        options[row_index-1] = []
        
        build_verbal_options_for_question(question,row,row_index,options)
        
      rescue Exception => e
        Rails.logger.info("ERROR_EXCEL_getQuestionFromRow:" + e.message.to_s)
        return nil
      end
        
      
      return question
      
      
    end
    
     # Generate a question object by reading a row from excel.
    # Also add option objects to the question object.
    def build_verbal_options_for_question(question,row,row_index,options)
      
      curr_options = []
      
      if question.type == Type.find_by_code("V-MCQ-1")
        
        option = row[8].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 1) 
        
        option = row[9].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 2) 
        
        option = row[10].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 3)
        
        option = row[11].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 4)
        
        option = row[12].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 5)
        
        # set correct option 
        curr_options[row[7].to_i-1].correct = true
        
      elsif question.type == Type.find_by_code("V-MCQ-2")
        
        option = row[8].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 1)
        
        option = row[9].to_s.strip 
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 2)
         
        option = row[10].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 3)
        
        # set correct options
        row[7].to_s.split(",").each do |correct_index|
           curr_options[correct_index.to_i-1].correct = true
        end
        
      elsif question.type == Type.find_by_code("V-SIP")
        # Option with 0 based answer sentence index.
        option = row[7].to_s.strip
        option_int = option.to_i - 1
        curr_options << (Option.new :content => (option == "" ? nil : option_int),:correct => true,:sequence_no => 1)
        
      elsif question.type == Type.find_by_code("V-TC-1")
        
        option = row[8].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 1)
        
        option = row[9].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 2)
        
        option = row[10].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 3)
        
        option = row[11].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 4)
        
        option = row[12].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 5)
        
        # set correct option 
        curr_options[row[7].to_i-1].correct = true
        
      elsif question.type == Type.find_by_code("V-TC-2")
        
        option = row[8].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 1)
        
        option = row[9].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 2)
        
        option = row[10].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 3)
        
        option = row[11].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 4)
        
        option = row[12].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 5)
        
        option = row[13].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 6)

        # set correct options
        correct_options = row[7].to_s.split(",")
        
        curr_options[correct_options[0].to_i-1].correct = true
        curr_options[correct_options[1].to_i+2].correct = true
        
      elsif question.type == Type.find_by_code("V-TC-3")
        
        option = row[8].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 1)
        
        option = row[9].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 2)
        
        option = row[10].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 3)
        
        option = row[11].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 4)
        
        option = row[12].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 5)
        
        option = row[13].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 6)
        
        option = row[14].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 7)
        
        option = row[15].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 8)
        
        option = row[16].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 9)
        
        # set correct options
        correct_options = row[7].to_s.split(",")
        
        curr_options[correct_options[0].to_i-1].correct = true
        curr_options[correct_options[1].to_i+2].correct = true
        curr_options[correct_options[2].to_i+5].correct = true
        
      elsif question.type == Type.find_by_code("V-SE")
        
        option = row[8].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 1)
        
        option = row[9].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 2)
        
        option = row[10].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 3)
        
        option = row[11].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 4)
        
        option = row[12].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 5)
        
        option = row[13].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 6)
        
        # set correct options
        correct_options = row[7].to_s.split(",")
        
        curr_options[correct_options[0].to_i-1].correct = true
        curr_options[correct_options[1].to_i-1].correct = true
      
      end
      
      options[row_index-1] = curr_options
      
    end
    
     #############################################################################
    #############################################################################
    #------------------------ QUANT PRIVATES HELPERS----------------------------#
    #############################################################################
    #############################################################################
    
    # Criteria 3: Check if correct column names exist for the verbal sheet.
    def are_quant_sheet_colums_valid?
      
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
                       
        if (@workbook.worksheet 0).row(0).at(i).to_s != correct_name
          @error_messages << ("Sheet => #{(@workbook.worksheet 0).name},Incorrect Column # #{(i+1).to_s} => #{(@workbook.worksheet 0).row(0).at(i).to_s},Required Column => #{correct_name}")
          return false
        end            

      end

      return true
      
    end
    
    # Criteria 5: Check if Type column has valid entries & matching option set.
    def are_quant_que_types_and_optionsets_valid?
      
      # TODO: Return false if a invalid entry found.
      
      return true
    end
    
    # Create question objects by reading each row of the current sheet.
    # Add questions to the section object.
    def create_quant_questions(quant_sheet,quant_section,questions,options)
      
      # Start from row at index 1
      (1..20).each do |row_index|
        
        # Get current question and add it to the section.
        curr_que = getQuantQuestionFromRow(quant_sheet,quant_section,questions,options,row_index)
        
        questions << curr_que
        
      end
        
    end
    
    # Generate a question object by reading a row from excel.
    # Also add option objects to the question object.
    def getQuantQuestionFromRow(quant_sheet,quant_section,questions,options,row_index)
      
      Rails.logger.info("Creating quant question = " + row_index.to_s)
      
      row = quant_sheet.row(row_index)
      
      question = Question.new
      
      begin
        
        sequence_no = row[0].to_s.strip
        question.sequence_no = (sequence_no == "") ? nil : row[0].to_i
        
        di_location = row[2].to_s.strip
        question.di_location = (di_location == "") ? nil : di_location
        
        instruction = row[4].to_s.strip
        question.instruction = (instruction == "") ? nil : instruction
        
        passage = row[5].to_s.strip
        question.passage = (passage == "") ? nil : passage
        
        que_text = row[6].to_s.strip
        question.que_text = (que_text == "") ? nil : que_text
        
        que_image = row[7].to_s.strip
        question.que_image = (que_image == "") ? nil : que_image
        
        sol_text = row[8].to_s.strip
        question.sol_text = (sol_text == "") ? nil : sol_text
        
        sol_image = row[9].to_s.strip
        question.sol_image = (sol_image == "") ? nil : sol_image
        
        quantity_a = row[10].to_s.strip
        question.quantity_a = (quantity_a == "") ? nil : quantity_a
        
        quantity_b = row[11].to_s.strip
        question.quantity_b = (quantity_b == "") ? nil : quantity_b
        
        option_set_count = row[12].to_s.strip
        question.option_set_count = (option_set_count == "") ? nil : option_set_count.to_i
        
        # Question references.
        question.topic_id = Topic.find_by_name(row[3].to_s).id
        question.type = Type.find_by_code(row[1].to_s)
      
        Rails.logger.info("curr_sheet_index = " + @curr_sheet_index.to_s + " row_index = " + row_index.to_s)
        
        options[row_index-1] = []
        
        build_quant_options_for_question(question,row,row_index,options)
        
      rescue Exception => e
        Rails.logger.info("ERROR_EXCEL_getQuestionFromRow:" + e.message.to_s)
        return nil
      end
        
      
      return question
      
      
    end
    
     # Generate a question object by reading a row from excel.
    # Also add option objects to the question object.
    def build_quant_options_for_question(question,row,row_index,options)
      
      curr_options = []
      
      if question.type == Type.find_by_code("Q-QC")
        
        option = row[14].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 1)
        
        option = row[15].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 2)
        
        option = row[16].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 3)
        
        option = row[17].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 4)
        
        # set correct option 
        curr_options[row[13].to_i-1].correct = true
        
      elsif ((question.type == Type.find_by_code("Q-MCQ-1")) || (question.type == Type.find_by_code("Q-DI-MCQ-1")))
        
        option = row[14].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 1)
        
        option = row[15].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 2)
        
        option = row[16].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 3)
        
        option = row[17].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 4)
        
        option = row[18].to_s.strip
        curr_options << (Option.new :content => (option == "" ? nil : option),:correct => false,:sequence_no => 5)
        
        # set correct option 
        curr_options[row[13].to_i-1].correct = true
        
      elsif ((question.type == Type.find_by_code("Q-MCQ-2")) || (question.type == Type.find_by_code("Q-DI-MCQ-2")))
        
        (1..(row[12].to_i)).each do |option_index|
          option = row[13+option_index].to_s.strip
          curr_options <<  (Option.new :content => option,:correct => false,:sequence_no => option_index)
        end
        
        # set correct options
        row[13].to_s.split(",").each do |correct_index|
          curr_options[correct_index.to_i-1].correct = true
        end
        
      elsif ((question.type == Type.find_by_code("Q-NE-1")) || (question.type == Type.find_by_code("Q-DI-NE-1"))) 
        
        option = row[13].to_s.strip 
        curr_options << (Option.new :content => option,:correct => true,:sequence_no => 1)
      
      elsif ((question.type == Type.find_by_code("Q-NE-2")) || (question.type == Type.find_by_code("Q-DI-NE-2")))
        
        option = row[13].to_s.strip
        curr_options << (Option.new :content => option,:correct => true,:sequence_no => 1)
      
      end
      
      options[row_index-1] = curr_options
      
    end
    
  end
end