class StudentsController < ApplicationController
  def index
    @students = Role.find_by_name("Student").users
  end
end
