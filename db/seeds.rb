# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Generate roles.
super_admin_role = Role.new
super_admin_role.name = "SuperAdmin"
super_admin_role.save!

admin_role = Role.new
admin_role.name = "Admin"
admin_role.save!

publisher_role = Role.new
publisher_role.name = "Publisher"
publisher_role.save!

student_role = Role.new
student_role.name = "Student"
student_role.save!

# Generate users for each role.
super_admin_user = User.create!(:full_name => 'Harshal Bhakta', :email => 'harshal.c.bhakta@gmail.com', :password => 'password', :password_confirmation => 'password')
super_admin_user.roles << super_admin_role
super_admin_user.save!

admin_user = User.create!(:full_name => 'Admin', :email => 'admin@gre340.com', :password => 'password', :password_confirmation => 'password')
admin_user.roles << admin_role
admin_user.save!

publisher_user = User.create!(:full_name => 'Publisher', :email => 'publisher@gre340.com', :password => 'password', :password_confirmation => 'password')
publisher_user.roles << publisher_role
publisher_user.save!

student1_user = User.create!(:full_name => 'Student One', :email => 'student1@gre340.com', :password => 'password', :password_confirmation => 'password')
student1_user.roles << student_role
student1_user.save!

student2_user = User.create!(:full_name => 'Student Two', :email => 'student2@gre340.com', :password => 'password', :password_confirmation => 'password')
student2_user.roles << student_role
student2_user.save!

User.update_all ["confirmed_at = ?", Time.now]

# Generate SectionTypes.  
["Main","Verbal", "Quant"].each do | section_type_name |
  SectionType.find_or_create_by_name_and_instruction(section_type_name,"Total Questions: 20 & Total Time: 30 minutes")
end

main_section_type = SectionType.find_by_name("Main")

# Generate Categories.
[ { :code => "Mathematics", :name => "Mathematics"}, 
  { :code => "Science", :name => "Science"},
  { :code => "English", :name => "English"},
  { :code => "Social Studies", :name => "Social Studies"},
  { :code => "Computer", :name => "Computer"},
  { :code => "General Knowledge", :name => "General Knowledge"}].each do |category|
  Category.find_or_create_by_code_and_name(category[:code],category[:name])
end

# Generate Topics.
["Integers",
"Fractions",
"Decimals",
"Exponents and Square Roots",
"Ordering and the Real Number Line",
"Percent",
"Ratio and Proportion",
"Absolute Value",
"Averages & Weighted Averages",
"Time and Work",
"Time, Speed and Distance",
"Algebraic Expressions",
"Rules of Exponents",
"Linear and Quadratic Equations",
"Graphs",
"Inequalities",
"Co-ordinate Geometry",
"Functions",
"Geometry",
"Probability",
"Permutation and Combination",
"Measures of Central Location",
"Data Representation and Interpretation",
"Measures of Dispersion",
"Frequency Distribution",
"Advanced Statistics"].each do |topic_name|
  topic = Topic.find_by_name(topic_name) 
  
  if(!topic)
    topic = Topic.create(:name => topic_name)
    topic.section_type_id = nil
    topic.save!
  end
  
end

# Generate Types.
[ { :code => "V-MCQ-1", :name => "Verbal - Select 1 of 5", :category => nil }, 
  { :code => "V-MCQ-2", :name => "Verbal - Select all correct of 3", :category => nil },
  { :code => "V-SIP",   :name => "Verbal - Select in passage", :category => nil },
  { :code => "V-TC-1",  :name => "Verbal - Text completion [1 Blank,5 Options]", :category => nil },
  { :code => "V-TC-2",  :name => "Verbal - Text completion [2 Blank,6 Options]", :category => nil },
  { :code => "V-TC-3",  :name => "Verbal - Text completion [3 Blank,9 Options]", :category => nil },
  { :code => "V-SE",    :name => "Verbal - Sentence Equivalance [1 Blank,6 Options]", :category => nil },
  { :code => "Q-QC",    :name => "Quant - Compare A/B", :category => nil },
  { :code => "Q-MCQ-1",    :name => "Quant - Select 1 of 5", :category => nil },
  { :code => "Q-MCQ-2",    :name => "Quant - Select all correct", :category => nil },
  { :code => "Q-NE-1",     :name => "Quant - NE [ 1 Textbox ]", :category => nil },
  { :code => "Q-NE-2",     :name => "Quant - NE [ 2 Textboxes ]", :category => nil },
  { :code => "Q-DI-MCQ-1", :name => "Quant - DI + MCQ1", :category => nil },
  { :code => "Q-DI-MCQ-2", :name => "Quant - DI + MCQ2", :category => nil },
  { :code => "Q-DI-NE-1",  :name => "Quant - DI + NE1", :category => nil },
  { :code => "Q-DI-NE-2",  :name => "Quant - DI + NE2", :category => nil }].each do |type_hash|
  
  type = Type.find_by_code(type_hash[:code]) 
  
  if(!type)
    type = Type.create(:code => type_hash[:code],:name => type_hash[:name])
    type.category = nil
    type.save!
  end

end

# Generate QuitTypes.
["FullQuiz", "SectionQuiz", "CategoryQuiz", "TopicQuiz"].each do | quiz_type_name |
  QuizType.find_or_create_by_name(quiz_type_name)
end
  
category_quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  
# Create 5 Category-wise quiz for RC + Practice [ 1 Free + 4 Paid ]

Category.all.each do |category|
  
  (1..5).each do |index|
    category_quiz = Quiz.new
    category_quiz.name = "#{category.name} 10" + (index).to_s
    category_quiz.desc = "#{category.name} 10" + (index).to_s + " description"
    category_quiz.random = false
    category_quiz.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
    category_quiz.category_id = category.id
    category_quiz.published = true
    category_quiz.approved = true
    category_quiz.price = 0.0
    category_quiz.save!
  end
  
end
  
# Add 3 packages for full-quiz section in store.
package_1 = Package.new
package_1.name = "able"
package_1.desc = "5 awesome full-length tests"
package_1.price = 899.00
package_1.position = 1
package_1.save!

package_2 = Package.new
package_2.name = "ace"
package_2.desc = "7 awesome full-length tests"
package_2.price = 999.00
package_2.position = 2
package_2.save!

package_3 = Package.new
package_3.name = "ninja"
package_3.desc = "10 awesome full-length tests"
package_3.price = 1099.00
package_3.position = 3
package_3.save!

(130..170).each do |index|
  scaled_score = ScaledScore.new
  scaled_score.value = index
  case index
    when 130
      scaled_score.verbal_score = 0
      scaled_score.quant_score = 0
    when 131
      scaled_score.verbal_score = 1
      scaled_score.quant_score = 1
    when 132
      scaled_score.verbal_score = 1
      scaled_score.quant_score = 1
    when 133
      scaled_score.verbal_score = 1
      scaled_score.quant_score = 1
    when 134
      scaled_score.verbal_score = 2
      scaled_score.quant_score = 1
    when 135
      scaled_score.verbal_score = 3
      scaled_score.quant_score = 2
    when 136
      scaled_score.verbal_score = 4
      scaled_score.quant_score = 3
    when 137
      scaled_score.verbal_score = 5
      scaled_score.quant_score = 4
    when 138
      scaled_score.verbal_score = 6
      scaled_score.quant_score = 5
    when 139
      scaled_score.verbal_score = 8
      scaled_score.quant_score = 7
    when 140
      scaled_score.verbal_score = 10
      scaled_score.quant_score = 9
    when 141
      scaled_score.verbal_score = 12
      scaled_score.quant_score = 11
    when 142
      scaled_score.verbal_score = 15
      scaled_score.quant_score = 14
    when 143
      scaled_score.verbal_score = 18
      scaled_score.quant_score = 17
    when 144
      scaled_score.verbal_score = 21
      scaled_score.quant_score = 20
    when 145
      scaled_score.verbal_score = 24
      scaled_score.quant_score = 23
    when 146
      scaled_score.verbal_score = 28
      scaled_score.quant_score = 27
    when 147
      scaled_score.verbal_score = 32
      scaled_score.quant_score = 31
    when 148
      scaled_score.verbal_score = 36
      scaled_score.quant_score = 35
    when 149
      scaled_score.verbal_score = 40
      scaled_score.quant_score = 39
    when 150
      scaled_score.verbal_score = 44
      scaled_score.quant_score = 43
    when 151
      scaled_score.verbal_score = 49
      scaled_score.quant_score = 14
    when 152
      scaled_score.verbal_score = 53
      scaled_score.quant_score = 52
    when 153
      scaled_score.verbal_score = 57
      scaled_score.quant_score = 56
    when 154
      scaled_score.verbal_score = 61
      scaled_score.quant_score = 60
    when 155
      scaled_score.verbal_score = 65
      scaled_score.quant_score = 64
    when 156
      scaled_score.verbal_score = 69
      scaled_score.quant_score = 68
    when 157
      scaled_score.verbal_score = 73
      scaled_score.quant_score = 71
    when 158
      scaled_score.verbal_score = 77
      scaled_score.quant_score = 74
    when 159
      scaled_score.verbal_score = 80
      scaled_score.quant_score = 77
    when 160
      scaled_score.verbal_score = 83
      scaled_score.quant_score = 81
    when 161
      scaled_score.verbal_score = 86
      scaled_score.quant_score = 83
    when 162
      scaled_score.verbal_score = 89
      scaled_score.quant_score = 86
    when 163
      scaled_score.verbal_score = 91
      scaled_score.quant_score = 88
    when 164
      scaled_score.verbal_score = 93
      scaled_score.quant_score = 90
    when 165
      scaled_score.verbal_score = 95
      scaled_score.quant_score = 92
    when 166
      scaled_score.verbal_score = 96
      scaled_score.quant_score = 94
    when 167
      scaled_score.verbal_score = 97
      scaled_score.quant_score = 96
    when 168
      scaled_score.verbal_score = 98
      scaled_score.quant_score = 97
    when 169
      scaled_score.verbal_score = 99
      scaled_score.quant_score = 98
    when 170
      scaled_score.verbal_score = 99
      scaled_score.quant_score = 99
    else
      scaled_score.verbal_score = 0
      scaled_score.quant_score = 0
  end
  scaled_score.save!
end
File.open(Rails.root.join("app/assets/files/words.txt")) do |dictionary|
  dictionary.read.each_line do |record|
    word, meaning = record.chomp.split("\t")
    Dictionary.create!(:word => word, :meaning => meaning)
  end
end

# Add OfferCodes
add_credits_on_confirm_offer_code = OfferCode.create!(:code => "add_credits_on_confirm")
add_items_on_confirm_offer_code = OfferCode.create!(:code => "add_items_on_confirm")


