# Class to upload full test excel.
module UploadExcel
  class FullQuizUploader
    
    def initialize(_workbook,_quiz)
      
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
      
      Rails.logger.info("VALIDATION PASSED")
      
      return true
      
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
        
          Rails.logger.info("Processing Verbal Sheet")
          
          # return false if processing fails for a sheet.
          if !process_verbal_sheet
            return false
          end
        
        elsif ((@curr_sheet.name == "QUANT-1") || (@curr_sheet.name  == "QUANT-2"))
        
          Rails.logger.info("Processing Quant Sheet")
        
          # return false if processing fails for a sheet.
          if !process_quant_sheet            
            return false
          end
        
        end 
        
      end
      
      @success_messages << "sections = " << @sections.count.to_s
      @success_messages << "section 1 Questions = " << @questions[0].count.to_s
      @success_messages << "section 2 Questions = " << @questions[1].count.to_s
      
      # Save the objects stored in the array.
      if !save_objects_to_db
        @error_messages << "Saving objects to db failed"
        return false
      end
      
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
    
    # Criteria 1: There should be minimum 5 sheets
    def workbook_has_5_sheets?
      
      if ( @sheets[0] == nil || @sheets[1] == nil || @sheets[2] == nil || @sheets[3] == nil || @sheets[4] == nil )
        @error_messages << "Minimum 5 sheets required."
        return false 
      end
      
      return true
      
    end
    
    # Criteria 2: First 4 sheets should contain all of - "VERBAL-1","VERBAL-2","QUANT-1" and "QUANT-1".
    def workbook_has_4_correct_sheets?
      sheet_names = [] << @sheets[0].name << @sheets[1].name << @sheets[2].name << @sheets[3].name
      
      if ((sheet_names & [ "VERBAL-1", "VERBAL-2", "QUANT-1", "QUANT-2" ]).count != 4)
        @error_messages << "First 4 sheets should contain all of : VERBAL-1, VERBAL-2, QUANT-1 and QUANT-2."
        return false
      end
      
      return true
    end
      
    # Criteria 3: DATA should be the last sheet.
    def workbook_has_5th_data_sheet?
      if (@sheets[4].name != "DATA")
        @error_messages << "Last data sheet should be DATA."
        return false
      end
      
      return true
    end
    
    # Criteria 4: Check if correct column names exist for the sheets.
    def are_sheet_colums_valid?
      
      @sheets.each do | sheet |
          
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
    
    # Process a verbal sheet.
    # return true is processing is successful.
    # return false for unexpected results.
    def process_verbal_sheet
    
      # Create the verbal section
      verbal_section = Section.new :name => @curr_sheet.name, 
                                   :sequence_no => @curr_sheet_index, 
                                   :section_type_id => SectionType.find_by_name("Verbal").id
      verbal_section.quiz = @quiz
      
      @questions[@curr_sheet_index] = []
      @options[@curr_sheet_index] = []
      
      # Create questions under the created section
      create_verbal_questions(verbal_section)
      
      @sections << verbal_section
      
      Rails.logger.info("Section added. Section count = " + @sections.to_s)
        
      return true
    end
    
    # Process a quant sheet.
    # return true is processing is successful.
    # return false for unexpected results.
    def process_quant_sheet
      # Create the quant section
      quant_section = Section.new :name => @curr_sheet.name, 
                                   :sequence_no => @curr_sheet_index, 
                                   :section_type_id => SectionType.find_by_name("Quant").id
      quant_section.quiz = @quiz
      
      @questions[@curr_sheet_index] = []
      @options[@curr_sheet_index] = []
      
      # Create questions under the created section
      create_quant_questions(quant_section)
      
      @sections << quant_section
      
      Rails.logger.info("Section added. Section count = " + @sections.to_s)
        
      return true
    end
    
    # Create question objects by reading each row of the current sheet.
    # Add questions to the section object.
    def create_verbal_questions(section)
      
      # Start from row at index 1
      (1..20).each do |row_index|
        
        # Get current question and add it to the section.
        curr_que = getVerbalQuestionFromRow(row_index)
        
        @questions[@curr_sheet_index] << curr_que
        
      end
        
    end
    
    # Generate a question object by reading a row from excel.
    # Also add option objects to the question object.
    def getVerbalQuestionFromRow(row_index)
      
      Rails.logger.info("Creating verbal question = " + row_index.to_s)
      
      row = @curr_sheet.row(row_index)
      
      question = Question.new
      
      begin
        
        question.sequence_no = row[0].to_i
        question.header = row[2].to_s
        question.passage = row[3].to_s
        question.que_text = row[4].to_s
        question.sol_text = row[5].to_s
        question.option_set_count = row[6].to_i
        question.que_image = nil
        question.sol_image = nil
        question.di_location = nil
        question.quantity_a = nil
        question.quantity_b = nil
        
        # Question references.
        question.type = Type.find_by_code(row[1].to_s)
        question.topic = nil
      
        Rails.logger.info("curr_sheet_index = " + @curr_sheet_index.to_s + " row_index = " + row_index.to_s)
        
        @options[@curr_sheet_index][row_index-1] = []
        
        build_options_for_question(question,row,row_index)
        
      rescue Exception => e
        Rails.logger.info("ERROR_EXCEL_getQuestionFromRow:" + e.message.to_s)
        return nil
      end
        
      
      return question
      
      
    end
    
     # Generate a question object by reading a row from excel.
    # Also add option objects to the question object.
    def build_options_for_question(question,row,row_index)
      
      options = []
      
      if question.type == Type.find_by_code("V-MCQ-1")
        
        options << (Option.new :content => row[8].to_s,:correct => false) 
        options << (Option.new :content => row[9].to_s,:correct => false) 
        options << (Option.new :content => row[10].to_s,:correct => false)
        options << (Option.new :content => row[11].to_s,:correct => false)
        options << (Option.new :content => row[12].to_s,:correct => false)
        
        # set correct option 
        options[row[7].to_i-1].correct = true
        
      elsif question.type == Type.find_by_code("V-MCQ-2")
        
        options << (Option.new :content => row[8].to_s,:correct => false) 
        options << (Option.new :content => row[9].to_s,:correct => false) 
        options << (Option.new :content => row[10].to_s,:correct => false)
        
        # set correct options
        row[7].to_s.split(",").each do |correct_index|
           options[correct_index.to_i-1].correct = true
        end
        
      elsif question.type == Type.find_by_code("V-SIP")
        # No options
      elsif question.type == Type.find_by_code("V-TC-1")
        
        options << (Option.new :content => row[8].to_s,:correct => false) 
        options << (Option.new :content => row[9].to_s,:correct => false) 
        options << (Option.new :content => row[10].to_s,:correct => false)
        options << (Option.new :content => row[11].to_s,:correct => false)
        options << (Option.new :content => row[12].to_s,:correct => false)
        
        # set correct option 
        options[row[7].to_i-1].correct = true
        
      elsif question.type == Type.find_by_code("V-TC-2")
        
        options << (Option.new :content => row[8].to_s,:correct => false) 
        options << (Option.new :content => row[9].to_s,:correct => false) 
        options << (Option.new :content => row[10].to_s,:correct => false)
        options << (Option.new :content => row[11].to_s,:correct => false)
        options << (Option.new :content => row[12].to_s,:correct => false)
        options << (Option.new :content => row[13].to_s,:correct => false)
        
        # set correct options
        correct_options = row[7].to_s.split(",")
        
        options[correct_options[0].to_i-1].correct = true
        options[correct_options[1].to_i+2].correct = true
        
      elsif question.type == Type.find_by_code("V-TC-3")
        
        options << (Option.new :content => row[8].to_s,:correct => false) 
        options << (Option.new :content => row[9].to_s,:correct => false) 
        options << (Option.new :content => row[10].to_s,:correct => false)
        options << (Option.new :content => row[11].to_s,:correct => false)
        options << (Option.new :content => row[12].to_s,:correct => false)
        options << (Option.new :content => row[13].to_s,:correct => false)
        options << (Option.new :content => row[14].to_s,:correct => false)
        options << (Option.new :content => row[15].to_s,:correct => false)
        options << (Option.new :content => row[16].to_s,:correct => false)
        
        # set correct options
        correct_options = row[7].to_s.split(",")
        
        options[correct_options[0].to_i-1].correct = true
        options[correct_options[1].to_i+2].correct = true
        options[correct_options[2].to_i+5].correct = true
        
      elsif question.type == Type.find_by_code("V-SE")
        
        options << (Option.new :content => row[8].to_s,:correct => false) 
        options << (Option.new :content => row[9].to_s,:correct => false) 
        options << (Option.new :content => row[10].to_s,:correct => false)
        options << (Option.new :content => row[11].to_s,:correct => false)
        options << (Option.new :content => row[12].to_s,:correct => false)
        options << (Option.new :content => row[13].to_s,:correct => false)
        
        # set correct options
        correct_options = row[7].to_s.split(",")
        
        options[correct_options[0].to_i-1].correct = true
        options[correct_options[1].to_i-1].correct = true
        
      elsif question.type == Type.find_by_code("Q-QC")
        
        options << (Option.new :content => row[14].to_s,:correct => false) 
        options << (Option.new :content => row[15].to_s,:correct => false) 
        options << (Option.new :content => row[16].to_s,:correct => false)
        options << (Option.new :content => row[17].to_s,:correct => false)
        
        # set correct option 
        options[row[13].to_i-1].correct = true
        
      elsif ((question.type == Type.find_by_code("Q-MCQ-1")) || (question.type == Type.find_by_code("Q-DI-MCQ-1")))
        
        options << (Option.new :content => row[14].to_s,:correct => false) 
        options << (Option.new :content => row[15].to_s,:correct => false) 
        options << (Option.new :content => row[16].to_s,:correct => false)
        options << (Option.new :content => row[17].to_s,:correct => false)
        options << (Option.new :content => row[18].to_s,:correct => false)
        
        # set correct option 
        options[row[13].to_i-1].correct = true
        
      elsif ((question.type == Type.find_by_code("Q-MCQ-2")) || (question.type == Type.find_by_code("Q-DI-MCQ-2")))
        
        (1..(row[12].to_i)).each do |option_index|
          options <<  (Option.new :content => row[13+option_index].to_s,:correct => false)
        end
        
        # set correct options
        row[13].to_s.split(",").each do |correct_index|
          options[correct_index.to_i-1].correct = true
        end
        
      elsif ((question.type == Type.find_by_code("Q-NE-1")) || (question.type == Type.find_by_code("Q-DI-NE-1"))) 
        
        options << (Option.new :content => row[13].to_s,:correct => true) 
      
      elsif ((question.type == Type.find_by_code("Q-NE-2")) || (question.type == Type.find_by_code("Q-DI-NE-2")))
        
        options << (Option.new :content => row[13].to_s,:correct => true)
      
      end
      
      @options[@curr_sheet_index][row_index-1] = options
      
    end
    
    # Create question objects by reading each row of the current sheet.
    # Add questions to the section object.
    def create_quant_questions(section)
      
      # Start from row at index 1
      (1..20).each do |row_index|
        
        # Get current question and add it to the section.
        curr_que = getQuantQuestionFromRow(row_index)
        
        @questions[@curr_sheet_index] << curr_que
        
      end
        
    end
    
    # Generate a question object by reading a row from excel.
    # Also add option objects to the question object.
    def getQuantQuestionFromRow(row_index)
      
      Rails.logger.info("Creating quant question = " + row_index.to_s)
      
      row = @curr_sheet.row(row_index)
      
      question = Question.new
      
      begin
        
        question.sequence_no = row[0].to_i
        question.di_location = row[2].to_s
        question.header = row[4].to_s
        question.passage = row[5].to_s
        question.que_text = row[6].to_s
        question.que_image = (row[7].to_s == "-") ? nil : row[7].to_s
        question.sol_text = row[8].to_s
        question.sol_image = (row[9].to_s == "-") ? nil : row[9].to_s
        question.quantity_a = row[10].to_s
        question.quantity_b = row[11].to_s
        question.option_set_count = row[12].to_i
        
        # Question references.
        question.topic_id = Topic.find_by_name(row[3].to_s).id
        question.type = Type.find_by_code(row[1].to_s)
      
        Rails.logger.info("curr_sheet_index = " + @curr_sheet_index.to_s + " row_index = " + row_index.to_s)
        
        @options[@curr_sheet_index][row_index-1] = []
        
        build_options_for_question(question,row,row_index)
        
      rescue Exception => e
        Rails.logger.info("ERROR_EXCEL_getQuestionFromRow:" + e.message.to_s)
        return nil
      end
        
      
      return question
      
      
    end
    
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