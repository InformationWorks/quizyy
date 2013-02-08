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
["Verbal", "Quant"].each do | section_type_name |
  SectionType.find_or_create_by_name_and_instruction(section_type_name,"Total Questions: 20 & Total Time: 30 minutes")
end

verbal_section_type = SectionType.find_by_name("Verbal")
quant_section_type = SectionType.find_by_name("Quant")

# Generate Categories.
[ { :code => "RC", :name => "Reading Comprehension", :section_type_id => verbal_section_type.id}, 
  { :code => "TC", :name => "Text Completion", :section_type_id => verbal_section_type.id},
  { :code => "SE", :name => "Sentence Equivalence", :section_type_id => verbal_section_type.id},
  { :code => "QC", :name => "Quantitative Comparison", :section_type_id => quant_section_type.id},
  { :code => "MCQ", :name => "Multiple choice", :section_type_id => quant_section_type.id},
  { :code => "NE", :name => "Numeric Entry", :section_type_id => quant_section_type.id},
  { :code => "DI-MCQ", :name => "Data Interpretation-Multiple choice", :section_type_id => quant_section_type.id},
  { :code => "DI-NE", :name => "Data Interpretation-Numeric Entry", :section_type_id => quant_section_type.id}].each do |category|
  Category.find_or_create_by_code_and_name_and_section_type_id(category[:code],category[:name],category[:section_type_id])
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
    topic.section_type_id = quant_section_type.id
    topic.save!
  end
  
end

# Generate Types.
[ { :code => "V-MCQ-1", :name => "Verbal - Select 1 of 5", :category => Category.find_by_code("RC") }, 
  { :code => "V-MCQ-2", :name => "Verbal - Select all correct of 3", :category => Category.find_by_code("RC") },
  { :code => "V-SIP",   :name => "Verbal - Select in passage", :category => Category.find_by_code("RC") },
  { :code => "V-TC-1",  :name => "Verbal - Text completion [1 Blank,5 Options]", :category => Category.find_by_code("TC") },
  { :code => "V-TC-2",  :name => "Verbal - Text completion [2 Blank,6 Options]", :category => Category.find_by_code("TC") },
  { :code => "V-TC-3",  :name => "Verbal - Text completion [3 Blank,9 Options]", :category => Category.find_by_code("TC") },
  { :code => "V-SE",    :name => "Verbal - Sentence Equivalance [1 Blank,6 Options]", :category => Category.find_by_code("SE") },
  { :code => "Q-QC",    :name => "Quant - Compare A/B", :category => Category.find_by_code("QC") },
  { :code => "Q-MCQ-1",    :name => "Quant - Select 1 of 5", :category => Category.find_by_code("MCQ") },
  { :code => "Q-MCQ-2",    :name => "Quant - Select all correct", :category => Category.find_by_code("MCQ") },
  { :code => "Q-NE-1",     :name => "Quant - NE [ 1 Textbox ]", :category => Category.find_by_code("NE") },
  { :code => "Q-NE-2",     :name => "Quant - NE [ 2 Textboxes ]", :category => Category.find_by_code("NE") },
  { :code => "Q-DI-MCQ-1", :name => "Quant - DI + MCQ1", :category => Category.find_by_code("DI-MCQ") },
  { :code => "Q-DI-MCQ-2", :name => "Quant - DI + MCQ2", :category => Category.find_by_code("DI-MCQ") },
  { :code => "Q-DI-NE-1",  :name => "Quant - DI + NE1", :category => Category.find_by_code("DI-NE") },
  { :code => "Q-DI-NE-2",  :name => "Quant - DI + NE2", :category => Category.find_by_code("DI-NE") }].each do |type_hash|
  
  type = Type.find_by_code(type_hash[:code]) 
  
  if(!type)
    type = Type.create(:code => type_hash[:code],:name => type_hash[:name])
    type.category = type_hash[:category]
    type.save!
  end

end

# Generate QuitTypes.
["FullQuiz", "CategoryQuiz", "TopicQuiz"].each do | quiz_type_name |
  QuizType.find_or_create_by_name(quiz_type_name)
end
  
full_quiz_type_id = QuizType.find_by_name("FullQuiz").id
  
# Create 10 FullLengthQuiz [ Timed + Paid ]
(1..10).each do |index|
  full_quiz = Quiz.new
  full_quiz.name = "Full Length " + (index+100).to_s
  full_quiz.desc = "Full Length " + (index+100).to_s + " desc"
  full_quiz.random = false
  full_quiz.quiz_type_id = full_quiz_type_id 
  full_quiz.timed = true
  full_quiz.price = 99.0
  full_quiz.published = true  
  full_quiz.publisher_id = publisher_user.id
  full_quiz.published_at = DateTime.now
  full_quiz.approved = true
  full_quiz.approver_id = admin_user.id
  full_quiz.approved_at = DateTime.now
  full_quiz.save!
end

# 2 Full length test [ Timed + Free + Available by default ]
(1..2).each do |index|
  full_quiz = Quiz.new
  full_quiz.name = "Full Length Practice " + (index).to_s
  full_quiz.desc = "Full Length Practice " + (index).to_s + " desc"
  full_quiz.random = false
  full_quiz.quiz_type_id = full_quiz_type_id 
  full_quiz.timed = true
  full_quiz.price = 0.0
  full_quiz.published = true  
  full_quiz.publisher_id = publisher_user.id
  full_quiz.published_at = DateTime.now
  full_quiz.approved = true
  full_quiz.approver_id = admin_user.id
  full_quiz.approved_at = DateTime.now
  full_quiz.save!
end

# Create 5 Category-wise quiz for RC + Practice [ 1 Free + 4 Paid ]
(1..5).each do |index|
  rc_cat_quiz = Quiz.new
  rc_cat_quiz.name = "RC Practice " + (index).to_s
  rc_cat_quiz.desc = "RC Practice " + (index).to_s + " desc"
  rc_cat_quiz.random = false
  rc_cat_quiz.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  rc_cat_quiz.category_id = Category.find_by_code("RC").id
  rc_cat_quiz.timed = false
  rc_cat_quiz.price = 99.0
  # First one is free
  if index == 1
    rc_cat_quiz.price = 0.0
  end
  
  rc_cat_quiz.save!
end

# Create 2 Category-wise quiz for RC + Timed [ 2 Paid ]
(1..2).each do |index|
  qc_cat_quiz = Quiz.new
  qc_cat_quiz.name = "RC Timed " + (index).to_s
  qc_cat_quiz.desc = "RC Timed " + (index).to_s + " desc"
  qc_cat_quiz.random = false
  qc_cat_quiz.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  qc_cat_quiz.category_id = Category.find_by_code("RC").id
  qc_cat_quiz.timed = true
  qc_cat_quiz.price = 99.0
  qc_cat_quiz.save!
end

# Create 5 Category-wise quiz for TC + Practice [ 1 Free + 4 Paid ]
(1..5).each do |index|
  tc_cat_quiz = Quiz.new
  tc_cat_quiz.name = "TC Practice " + (index).to_s
  tc_cat_quiz.desc = "TC Practice " + (index).to_s + " desc"
  tc_cat_quiz.random = false
  tc_cat_quiz.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  tc_cat_quiz.category_id = Category.find_by_code("TC").id
  tc_cat_quiz.timed = false
  tc_cat_quiz.price = 99.0
  
  # First one is free
  if index == 1
    tc_cat_quiz.price = 0.0
  end
  
  tc_cat_quiz.save!
end

# Create 2 Category-wise quiz for TC + Timed [ 2 Paid ]
(1..2).each do |index|
  qc_cat_quiz = Quiz.new
  qc_cat_quiz.name = "TC Timed " + (index).to_s
  qc_cat_quiz.desc = "TC Timed " + (index).to_s + " desc"
  qc_cat_quiz.random = false
  qc_cat_quiz.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  qc_cat_quiz.category_id = Category.find_by_code("TC").id
  qc_cat_quiz.timed = true
  qc_cat_quiz.price = 99.0
  qc_cat_quiz.save!
end

# Create 5 Category-wise quiz for SE + Practice [ 1 Free + 4 Paid ]
(1..5).each do |index|
  se_cat_quiz = Quiz.new
  se_cat_quiz.name = "SE Practice " + (index).to_s
  se_cat_quiz.desc = "SE Practice " + (index).to_s + " desc"
  se_cat_quiz.random = false
  se_cat_quiz.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  se_cat_quiz.category_id = Category.find_by_code("SE").id
  se_cat_quiz.timed = false
  se_cat_quiz.price = 99.0
  
  # First one is free
  if index == 1
    se_cat_quiz.price = 0.0
  end
  
  se_cat_quiz.save!
end

# Create 2 Category-wise quiz for SE + Timed [ 2 Paid ]
(1..2).each do |index|
  qc_cat_quiz = Quiz.new
  qc_cat_quiz.name = "SE Timed " + (index).to_s
  qc_cat_quiz.desc = "SE Timed " + (index).to_s + " desc"
  qc_cat_quiz.random = false
  qc_cat_quiz.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  qc_cat_quiz.category_id = Category.find_by_code("SE").id
  qc_cat_quiz.timed = true
  qc_cat_quiz.price = 99.0
  qc_cat_quiz.save!
end

# Create 5 Category-wise quiz for QC + Practice [ 1 Free + 4 Paid ]
(1..5).each do |index|
  qc_cat_quiz = Quiz.new
  qc_cat_quiz.name = "QC Practice " + (index).to_s
  qc_cat_quiz.desc = "QC Practice " + (index).to_s + " desc"
  qc_cat_quiz.random = false
  qc_cat_quiz.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  qc_cat_quiz.category_id = Category.find_by_code("QC").id
  qc_cat_quiz.timed = false
  qc_cat_quiz.price = 99.0
  
  # First one is free
  if index == 1
    qc_cat_quiz.price = 0.0
  end
  
  qc_cat_quiz.save!
end

# Create 2 Category-wise quiz for QC + Timed [ 2 Paid ]
(1..2).each do |index|
  qc_cat_quiz = Quiz.new
  qc_cat_quiz.name = "QC Timed " + (index).to_s
  qc_cat_quiz.desc = "QC Timed " + (index).to_s + " desc"
  qc_cat_quiz.random = false
  qc_cat_quiz.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  qc_cat_quiz.category_id = Category.find_by_code("QC").id
  qc_cat_quiz.timed = true
  qc_cat_quiz.price = 99.0
  qc_cat_quiz.save!
end

# Create 5 Category-wise quiz for QC + Practice [ 1 Free + 4 Paid ]
(1..5).each do |index|
  ne_cat_quiz = Quiz.new
  ne_cat_quiz.name = "NE Practice " + (index).to_s
  ne_cat_quiz.desc = "NE Practice " + (index).to_s + " desc"
  ne_cat_quiz.random = false
  ne_cat_quiz.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  ne_cat_quiz.category_id = Category.find_by_code("NE").id
  ne_cat_quiz.timed = false
  ne_cat_quiz.price = 99.0
  
  # First one is free
  if index == 1
    ne_cat_quiz.price = 0.0
  end
  
  ne_cat_quiz.save!
end

# Create 2 Category-wise quiz for NE + Timed [ 2 Paid ]
(1..2).each do |index|
  qc_cat_quiz = Quiz.new
  qc_cat_quiz.name = "NE Timed " + (index).to_s
  qc_cat_quiz.desc = "NE Timed " + (index).to_s + " desc"
  qc_cat_quiz.random = false
  qc_cat_quiz.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
  qc_cat_quiz.category_id = Category.find_by_code("NE").id
  qc_cat_quiz.timed = true
  qc_cat_quiz.price = 99.0
  qc_cat_quiz.save!
end

# Create 2 Category-wise quiz for RC + Timed + Paid


# Create 5 Topic-wise quiz for Integers + Practice [ 1 Free + 4 Paid ]
(1..5).each do |index|
  integers_quiz = Quiz.new
  integers_quiz.name = "Integers Practice " + (index).to_s
  integers_quiz.desc = "Integers Practice " + (index).to_s + " desc"
  integers_quiz.random = false
  integers_quiz.quiz_type = QuizType.find_by_name("TopicQuiz")
  integers_quiz.topic_id = Topic.find_by_name("Integers").id
  integers_quiz.timed = false
  integers_quiz.price = 99.0
  
  # First one is free
  if index == 1
    integers_quiz.price = 0.0
  end
  
  integers_quiz.save!
end

# Create 2 Topic-wise quiz for Integers + Timed [ 2 Paid ]
(1..2).each do |index|
  qc_cat_quiz = Quiz.new
  qc_cat_quiz.name = "Integers Timed " + (index).to_s
  qc_cat_quiz.desc = "Integers Timed " + (index).to_s + " desc"
  qc_cat_quiz.random = false
  qc_cat_quiz.quiz_type_id = QuizType.find_by_name("TopicQuiz").id
  qc_cat_quiz.topic_id = Topic.find_by_name("Integers").id
  qc_cat_quiz.timed = true
  qc_cat_quiz.price = 99.0
  qc_cat_quiz.save!
end

# Create 5 Topic-wise quiz for Integers + Practice [ 1 Free + 4 Paid ]
(1..5).each do |index|
  decimals_quiz = Quiz.new
  decimals_quiz.name = "Decimals Practice " + (index).to_s
  decimals_quiz.desc = "Decimals Practice " + (index).to_s + " desc"
  decimals_quiz.random = false
  decimals_quiz.quiz_type = QuizType.find_by_name("TopicQuiz")
  decimals_quiz.topic_id = Topic.find_by_name("Decimals").id
  decimals_quiz.timed = false
  decimals_quiz.price = 99.0
  
  # First one is free
  if index == 1
    decimals_quiz.price = 0.0
  end
  
  decimals_quiz.save!
end

# Create 2 Topic-wise quiz for Decimals + Timed [ 2 Paid ]
(1..2).each do |index|
  qc_cat_quiz = Quiz.new
  qc_cat_quiz.name = "Decimals Timed " + (index).to_s
  qc_cat_quiz.desc = "Decimals Timed " + (index).to_s + " desc"
  qc_cat_quiz.random = false
  qc_cat_quiz.quiz_type_id = QuizType.find_by_name("TopicQuiz").id
  qc_cat_quiz.topic_id = Topic.find_by_name("Decimals").id
  qc_cat_quiz.timed = true
  qc_cat_quiz.price = 99.0
  qc_cat_quiz.save!
end

# Create 5 Topic-wise quiz for Fractions + Practice [ 1 Free + 4 Paid ]
(1..5).each do |index|
  fractions_quiz = Quiz.new
  fractions_quiz.name = "Fractions Practice " + (index).to_s
  fractions_quiz.desc = "Fractions Practice " + (index).to_s + " desc"
  fractions_quiz.random = false
  fractions_quiz.quiz_type = QuizType.find_by_name("TopicQuiz")
  fractions_quiz.topic_id = Topic.find_by_name("Fractions").id
  fractions_quiz.timed = false
  fractions_quiz.price = 99.0
  
  # First one is free
  if index == 1
    fractions_quiz.price = 0.0
  end
  
  fractions_quiz.save!
end

# Create 2 Topic-wise quiz for Fractions + Timed [ 2 Paid ]
(1..2).each do |index|
  qc_cat_quiz = Quiz.new
  qc_cat_quiz.name = "Fractions Timed " + (index).to_s
  qc_cat_quiz.desc = "Fractions Timed " + (index).to_s + " desc"
  qc_cat_quiz.random = false
  qc_cat_quiz.quiz_type_id = QuizType.find_by_name("TopicQuiz").id
  qc_cat_quiz.topic_id = Topic.find_by_name("Fractions").id
  qc_cat_quiz.timed = true
  qc_cat_quiz.price = 99.0
  qc_cat_quiz.save!
end

# Create 5 Topic-wise quiz for Exp. & Sq. roots + Practice [ 1 Free + 4 Paid ]
(1..5).each do |index|
  exp_sq_quiz = Quiz.new
  exp_sq_quiz.name = "Exp. & Sq. roots Practice " + (index).to_s
  exp_sq_quiz.desc = "Exp. & Sq. roots Practice " + (index).to_s + " desc"
  exp_sq_quiz.random = false
  exp_sq_quiz.quiz_type = QuizType.find_by_name("TopicQuiz")
  exp_sq_quiz.topic_id = Topic.find_by_name("Exponents and Square Roots").id
  exp_sq_quiz.timed = false
  exp_sq_quiz.price = 99.0
  
  # First one is free
  if index == 1
    exp_sq_quiz.price = 0.0
  end
  
  exp_sq_quiz.save!
end

# Create 2 Topic-wise quiz for Exponents and Square Roots + Timed [ 2 Paid ]
(1..2).each do |index|
  qc_cat_quiz = Quiz.new
  qc_cat_quiz.name = "Exp. & Sq. roots Timed " + (index).to_s
  qc_cat_quiz.desc = "Exp. & Sq. roots Timed " + (index).to_s + " desc"
  qc_cat_quiz.random = false
  qc_cat_quiz.quiz_type_id = QuizType.find_by_name("TopicQuiz").id
  qc_cat_quiz.topic_id = Topic.find_by_name("Exponents and Square Roots").id
  qc_cat_quiz.timed = true
  qc_cat_quiz.price = 99.0
  qc_cat_quiz.save!
end

# Create 5 Topic-wise quiz for Ordering & real number line + Practice [ 1 Free + 4 Paid ]
(1..5).each do |index|
  ord_re_quiz = Quiz.new
  ord_re_quiz.name = "Ordering & real number line Practice " + (index).to_s
  ord_re_quiz.desc = "Ordering & real number line Practice " + (index).to_s + " desc"
  ord_re_quiz.random = false
  ord_re_quiz.quiz_type = QuizType.find_by_name("TopicQuiz")
  ord_re_quiz.topic_id = Topic.find_by_name("Ordering and the Real Number Line").id
  ord_re_quiz.timed = false
  ord_re_quiz.price = 99.0
  
  # First one is free
  if index == 1
    ord_re_quiz.price = 0.0
  end
  
  ord_re_quiz.save!
end

# Create 2 Topic-wise quiz for Ordering & real number line + Timed [ 2 Paid ]
(1..2).each do |index|
  qc_cat_quiz = Quiz.new
  qc_cat_quiz.name = "Ordering & real number line " + (index).to_s
  qc_cat_quiz.desc = "Ordering & real number line " + (index).to_s + " desc"
  qc_cat_quiz.random = false
  qc_cat_quiz.quiz_type_id = QuizType.find_by_name("TopicQuiz").id
  qc_cat_quiz.topic_id = Topic.find_by_name("Ordering and the Real Number Line").id
  qc_cat_quiz.timed = true
  qc_cat_quiz.price = 99.0
  qc_cat_quiz.save!
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

# Add first 5 full quizzes to package 1.
(1..5).each do |index|
  package_quiz = PackageQuiz.new
  package_quiz.quiz_id = Quiz.find_by_name("Full Length " + (index+100).to_s).id
  package_quiz.package_id = package_1.id
  package_quiz.save!
end

# Add first 7 full quizzes to package 2.
(1..7).each do |index|
  package_quiz = PackageQuiz.new
  package_quiz.quiz_id = Quiz.find_by_name("Full Length " + (index+100).to_s).id
  package_quiz.package_id = package_2.id
  package_quiz.save!
end

# Add first 10 full quizzes to package 3.
(1..10).each do |index|
  package_quiz = PackageQuiz.new
  package_quiz.quiz_id = Quiz.find_by_name("Full Length " + (index+100).to_s).id
  package_quiz.package_id = package_3.id
  package_quiz.save!
end

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
