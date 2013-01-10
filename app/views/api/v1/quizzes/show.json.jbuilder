  
  # Quiz fields
  json.id @quiz.id
  json.name @quiz.name
  json.desc @quiz.desc
  json.quiz_type_id @quiz.quiz_type_id
  json.quiz_type_name @quiz.quiz_type ? @quiz.quiz_type.name : nil
  json.category_id @quiz.category_id
  json.category_name @quiz.category ? @quiz.category.name : nil
  json.topic_id @quiz.topic_id
  json.topic_name @quiz.topic ? @quiz.topic.name : nil
  json.random @quiz.random
  
  ## Sections
  json.sections @quiz.sections do |section|
  	  if (@current_section and section.sequence_no >= @current_section.sequence_no) or @current_section.nil?
          json.id section.id
          json.name section.name
          json.display_text section.display_text
          json.section_type_id section.section_type_id
          json.section_type_name section.section_type ? section.section_type.name : nil
          json.sequence_no section.sequence_no
          json.quiz_id section.quiz_id
          json.submitted false
          ### Questions
            	  json.questions section.questions do |question|
          	 	  json.id question.id
          	 	  json.di_location question.di_location
          		  json.instruction question.instruction
          		  json.option_set_count question.option_set_count
          		  json.passage question.passage
          		  json.quantity_a question.quantity_a
          		  json.quantity_b question.quantity_b
          		  json.que_image question.que_image_url
          		  json.que_text question.que_text
          		  json.sequence_no question.sequence_no
          		  json.sol_image question.sol_image_url
          		  json.sol_text question.sol_text
          		  json.topic_id question.topic_id
          		  json.topic_name question.topic ? question.topic.name : nil
          		  json.type_id question.type_id
          		  json.type_code question.type ? question.type.code : nil
          		  json.section_id question.section_id

          		  #### Options
          		  json.options question.options do |option|
          		    json.id option.id
          		    json.content option.content
          		    json.sequence_no option.sequence_no
          		    json.question_id option.question_id
            		  end
            	  end
      else
          json.id section.id
          json.submitted true
          json.sequence_no section.sequence_no
      end
  end