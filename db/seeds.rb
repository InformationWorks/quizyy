# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.delete_all
super_admin_role = Role.new
super_admin_role.name = "SuperAdmin"
super_admin_role.save!

admin_role = Role.new
admin_role.name = "Admin"
admin_role.save!

publisher_role = Role.new
publisher_role.name = "Publisher"
publisher_role.save!