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

# Generate Categories.
[ { :code => "RC", :name => "Reading Comprehension"}, 
  { :code => "TC", :name => "Text Completion"},
  { :code => "SE", :name => "Sentence Equivalence"},
  { :code => "QC", :name => "Quantitative Comparison"},
  { :code => "MCQ", :name => "Multiple choice"},
  { :code => "NE", :name => "Numeric Entry"},
  { :code => "DI-MCQ", :name => "Data Interpretation-Multiple choice"},
  { :code => "DI-NE", :name => "Data Interpretation-Numeric Entry"},].each do |category|
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
  Topic.find_or_create_by_name topic_name
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

# Generate SectionTypes.  
["Verbal", "Quant"].each do | section_type_name |
  SectionType.find_or_create_by_name_and_instruction(section_type_name,"Total Questions: 20 & Total Time: 30 minutes")
end
  
# Create 10 FullLengthQuiz [ Timed + Paid ]
full_quiz_type_id = QuizType.find_by_name("FullQuiz").id

full_quiz_1 = Quiz.new
full_quiz_1.name = "Full Length 101"
full_quiz_1.desc = "Full Length 101 desc"
full_quiz_1.random = false
full_quiz_1.quiz_type_id = full_quiz_type_id 
full_quiz_1.timed = true
full_quiz_1.price = 99.0
full_quiz_1.save!

full_quiz_2 = Quiz.new
full_quiz_2.name = "Full Length 102"
full_quiz_2.desc = "Full Length 102 desc"
full_quiz_2.random = false
full_quiz_2.quiz_type_id = full_quiz_type_id
full_quiz_2.timed = true
full_quiz_2.price = 99.0
full_quiz_2.save!

full_quiz_3 = Quiz.new
full_quiz_3.name = "Full Length 103"
full_quiz_3.desc = "Full Length 103 desc"
full_quiz_3.random = false
full_quiz_3.quiz_type_id = full_quiz_type_id
full_quiz_3.timed = true
full_quiz_3.price = 99.0
full_quiz_3.save!

full_quiz_4 = Quiz.new
full_quiz_4.name = "Full Length 104"
full_quiz_4.desc = "Full Length 104 desc"
full_quiz_4.random = false
full_quiz_4.quiz_type_id = full_quiz_type_id
full_quiz_4.timed = true
full_quiz_4.price = 99.0
full_quiz_4.save!

full_quiz_5 = Quiz.new
full_quiz_5.name = "Full Length 105"
full_quiz_5.desc = "Full Length 105 desc"
full_quiz_5.random = false
full_quiz_5.quiz_type_id = full_quiz_type_id
full_quiz_5.timed = true
full_quiz_5.price = 99.0
full_quiz_5.save!

full_quiz_6 = Quiz.new
full_quiz_6.name = "Full Length 106"
full_quiz_6.desc = "Full Length 106 desc"
full_quiz_6.random = false
full_quiz_6.quiz_type_id = full_quiz_type_id
full_quiz_6.timed = true
full_quiz_6.price = 99.0
full_quiz_6.save!

full_quiz_7 = Quiz.new
full_quiz_7.name = "Full Length 107"
full_quiz_7.desc = "Full Length 107 desc"
full_quiz_7.random = false
full_quiz_7.quiz_type_id = full_quiz_type_id
full_quiz_7.timed = true
full_quiz_7.price = 99.0
full_quiz_7.save!

full_quiz_8 = Quiz.new
full_quiz_8.name = "Full Length 108"
full_quiz_8.desc = "Full Length 108 desc"
full_quiz_8.random = false
full_quiz_8.quiz_type_id = full_quiz_type_id
full_quiz_8.timed = true
full_quiz_8.price = 99.0
full_quiz_8.save!

full_quiz_9 = Quiz.new
full_quiz_9.name = "Full Length 109"
full_quiz_9.desc = "Full Length 109 desc"
full_quiz_9.random = false
full_quiz_9.quiz_type_id = full_quiz_type_id
full_quiz_9.timed = true
full_quiz_9.price = 99.0
full_quiz_9.save!

full_quiz_10 = Quiz.new
full_quiz_10.name = "Full Length 110"
full_quiz_10.desc = "Full Length 110 desc"
full_quiz_10.random = false
full_quiz_10.quiz_type_id = full_quiz_type_id
full_quiz_10.timed = true
full_quiz_10.price = 99.0
full_quiz_10.save!

# 2 Full length test [ Practice + Free ]
full_quiz_11 = Quiz.new
full_quiz_11.name = "Full Length Practice 1"
full_quiz_11.desc = "Full Length Practice 1 desc"
full_quiz_11.random = false
full_quiz_11.quiz_type_id = full_quiz_type_id
full_quiz_11.timed = false
full_quiz_11.price = 0.0
full_quiz_11.save!

full_quiz_12 = Quiz.new
full_quiz_12.name = "Full Length Practice 2"
full_quiz_12.desc = "Full Length Practice 2 desc"
full_quiz_12.random = false
full_quiz_12.quiz_type_id = full_quiz_type_id
full_quiz_12.timed = false
full_quiz_12.price = 0.0
full_quiz_12.save!

# Create 5 Category-wise quiz for RC + Practice [ 1 Free + 4 Paid ]

# Create 2 Category-wise quiz for RC + Timed + Paid

# Create 5 Category-wise quiz for TC

# Create 5 Category-wise quiz for RC

# Create 5 Category-wise quiz for RC

# Create 5 Category-wise quiz for RC

cat_quiz_1 = Quiz.new
cat_quiz_1.name = "Reading Comprehension 1"
cat_quiz_1.desc = "Reading Comprehension 1 desc"
cat_quiz_1.random = false
cat_quiz_1.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
cat_quiz_1.category_id = Category.find_by_code("RC").id
cat_quiz_1.timed = true
cat_quiz_1.save!

cat_quiz_2 = Quiz.new
cat_quiz_2.name = "Text Completion 1"
cat_quiz_2.desc = "Text Completion 1 desc"
cat_quiz_2.random = false
cat_quiz_2.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
cat_quiz_2.category_id = Category.find_by_code("TC").id
cat_quiz_2.timed = false
cat_quiz_2.save!

cat_quiz_3 = Quiz.new
cat_quiz_3.name = "Sentence Equivalence 1"
cat_quiz_3.desc = "Sentence Equivalence 1 desc"
cat_quiz_3.random = false
cat_quiz_3.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
cat_quiz_3.category_id = Category.find_by_code("SE").id
cat_quiz_3.timed = false
cat_quiz_3.save!

cat_quiz_4 = Quiz.new
cat_quiz_4.name = "Quantitative Comparison 1"
cat_quiz_4.desc = "Quantitative Comparison 1 desc"
cat_quiz_4.random = false
cat_quiz_4.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
cat_quiz_4.category_id = Category.find_by_code("QC").id
cat_quiz_4.timed = false
cat_quiz_4.save!

cat_quiz_5 = Quiz.new
cat_quiz_5.name = "Numeric Entry 1"
cat_quiz_5.desc = "Numeric Entry 1 desc"
cat_quiz_5.random = false
cat_quiz_5.quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
cat_quiz_5.category_id = Category.find_by_code("NE").id
cat_quiz_5.timed = false
cat_quiz_5.save!

# Create 5 Topic-wise quiz
topic_quiz_1 = Quiz.new
topic_quiz_1.name = "Integers 1"
topic_quiz_1.desc = "Integers 1 desc"
topic_quiz_1.random = false
topic_quiz_1.quiz_type = QuizType.find_by_name("TopicQuiz")
topic_quiz_1.topic_id = Topic.find_by_name("Integers").id
topic_quiz_1.timed = true
topic_quiz_1.save!

topic_quiz_2 = Quiz.new
topic_quiz_2.name = "Fractions 1"
topic_quiz_2.desc = "Fractions 1 desc"
topic_quiz_2.random = false
topic_quiz_2.quiz_type = QuizType.find_by_name("TopicQuiz")
topic_quiz_2.topic_id = Topic.find_by_name("Fractions").id
topic_quiz_2.timed = false
topic_quiz_2.save!

topic_quiz_3 = Quiz.new
topic_quiz_3.name = "Decimals 1"
topic_quiz_3.desc = "Decimals 1 desc"
topic_quiz_3.random = false
topic_quiz_3.quiz_type = QuizType.find_by_name("TopicQuiz")
topic_quiz_3.topic_id = Topic.find_by_name("Decimals").id
topic_quiz_3.timed = false
topic_quiz_3.save!

topic_quiz_4 = Quiz.new
topic_quiz_4.name = "Exponents and Square Roots 1"
topic_quiz_4.desc = "Exponents and Square Roots 1 desc"
topic_quiz_4.random = false
topic_quiz_4.quiz_type = QuizType.find_by_name("TopicQuiz")
topic_quiz_4.topic_id = Topic.find_by_name("Exponents and Square Roots").id
topic_quiz_4.timed = false
topic_quiz_4.save!

topic_quiz_5 = Quiz.new
topic_quiz_5.name = "Ordering and the Real Number Line 1"
topic_quiz_5.desc = "Ordering and the Real Number Line 1 desc"
topic_quiz_5.random = false
topic_quiz_5.quiz_type = QuizType.find_by_name("TopicQuiz")
topic_quiz_5.topic_id = Topic.find_by_name("Ordering and the Real Number Line").id
topic_quiz_5.timed = false
topic_quiz_5.save!

# Assign 5 full test to student1.
quiz_user1 = QuizUser.new
quiz_user1.user_id = student1_user.id
quiz_user1.quiz_id = full_quiz_1.id
quiz_user1.save!

quiz_user2 = QuizUser.new
quiz_user2.user_id = student1_user.id
quiz_user2.quiz_id = full_quiz_2.id
quiz_user2.save!

quiz_user3 = QuizUser.new
quiz_user3.user_id = student1_user.id
quiz_user3.quiz_id = full_quiz_7.id
quiz_user3.save!

quiz_user4 = QuizUser.new
quiz_user4.user_id = student1_user.id
quiz_user4.quiz_id = full_quiz_8.id
quiz_user4.save!

quiz_user5 = QuizUser.new
quiz_user5.user_id = student1_user.id
quiz_user5.quiz_id = full_quiz_9.id
quiz_user5.save!

# Assign 3 Category test to student1.
quiz_user6 = QuizUser.new
quiz_user6.user_id = student1_user.id
quiz_user6.quiz_id = cat_quiz_1.id
quiz_user6.save!

quiz_user7 = QuizUser.new
quiz_user7.user_id = student1_user.id
quiz_user7.quiz_id = cat_quiz_2.id
quiz_user7.save!

quiz_user8 = QuizUser.new
quiz_user8.user_id = student1_user.id
quiz_user8.quiz_id = cat_quiz_3.id
quiz_user8.save!

# Assign 3 Topic test to student1.
quiz_user9 = QuizUser.new
quiz_user9.user_id = student1_user.id
quiz_user9.quiz_id = topic_quiz_1.id
quiz_user9.save!

quiz_user10 = QuizUser.new
quiz_user10.user_id = student1_user.id
quiz_user10.quiz_id = topic_quiz_2.id
quiz_user10.save!

quiz_user11 = QuizUser.new
quiz_user11.user_id = student1_user.id
quiz_user11.quiz_id = topic_quiz_3.id
quiz_user11.save!
  
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
package_quiz_1 = PackageQuiz.new
package_quiz_1.quiz_id = full_quiz_1.id
package_quiz_1.package_id = package_1.id
package_quiz_1.save!

package_quiz_2 = PackageQuiz.new
package_quiz_2.quiz_id = full_quiz_2.id
package_quiz_2.package_id = package_1.id
package_quiz_2.save!

package_quiz_3 = PackageQuiz.new
package_quiz_3.quiz_id = full_quiz_3.id
package_quiz_3.package_id = package_1.id
package_quiz_3.save!

package_quiz_4 = PackageQuiz.new
package_quiz_4.quiz_id = full_quiz_4.id
package_quiz_4.package_id = package_1.id
package_quiz_4.save!

package_quiz_5 = PackageQuiz.new
package_quiz_5.quiz_id = full_quiz_5.id
package_quiz_5.package_id = package_1.id
package_quiz_5.save!

# Add first 7 full quizzes to package 1.
package_quiz_6 = PackageQuiz.new
package_quiz_6.quiz_id = full_quiz_1.id
package_quiz_6.package_id = package_2.id
package_quiz_6.save!

package_quiz_7 = PackageQuiz.new
package_quiz_7.quiz_id = full_quiz_2.id
package_quiz_7.package_id = package_2.id
package_quiz_7.save!

package_quiz_8 = PackageQuiz.new
package_quiz_8.quiz_id = full_quiz_3.id
package_quiz_8.package_id = package_2.id
package_quiz_8.save!

package_quiz_9 = PackageQuiz.new
package_quiz_9.quiz_id = full_quiz_4.id
package_quiz_9.package_id = package_2.id
package_quiz_9.save!

package_quiz_10 = PackageQuiz.new
package_quiz_10.quiz_id = full_quiz_5.id
package_quiz_10.package_id = package_2.id
package_quiz_10.save!

package_quiz_11 = PackageQuiz.new
package_quiz_11.quiz_id = full_quiz_6.id
package_quiz_11.package_id = package_2.id
package_quiz_11.save!

package_quiz_12 = PackageQuiz.new
package_quiz_12.quiz_id = full_quiz_7.id
package_quiz_12.package_id = package_2.id
package_quiz_12.save!

# Add first 10 full quizzes to package 1.
package_quiz_13 = PackageQuiz.new
package_quiz_13.quiz_id = full_quiz_1.id
package_quiz_13.package_id = package_3.id
package_quiz_13.save!

package_quiz_14 = PackageQuiz.new
package_quiz_14.quiz_id = full_quiz_2.id
package_quiz_14.package_id = package_3.id
package_quiz_14.save!

package_quiz_15 = PackageQuiz.new
package_quiz_15.quiz_id = full_quiz_3.id
package_quiz_15.package_id = package_3.id
package_quiz_15.save!

package_quiz_16 = PackageQuiz.new
package_quiz_16.quiz_id = full_quiz_4.id
package_quiz_16.package_id = package_3.id
package_quiz_16.save!

package_quiz_17 = PackageQuiz.new
package_quiz_17.quiz_id = full_quiz_5.id
package_quiz_17.package_id = package_3.id
package_quiz_17.save!

package_quiz_18 = PackageQuiz.new
package_quiz_18.quiz_id = full_quiz_6.id
package_quiz_18.package_id = package_3.id
package_quiz_18.save!

package_quiz_19 = PackageQuiz.new
package_quiz_19.quiz_id = full_quiz_7.id
package_quiz_19.package_id = package_3.id
package_quiz_19.save!

package_quiz_20 = PackageQuiz.new
package_quiz_20.quiz_id = full_quiz_8.id
package_quiz_20.package_id = package_3.id
package_quiz_20.save!

package_quiz_21 = PackageQuiz.new
package_quiz_21.quiz_id = full_quiz_9.id
package_quiz_21.package_id = package_3.id
package_quiz_21.save!

package_quiz_22 = PackageQuiz.new
package_quiz_22.quiz_id = full_quiz_10.id
package_quiz_22.package_id = package_3.id
package_quiz_22.save!