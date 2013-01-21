class StudentsController < ApplicationController
  def new
    @student = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quiz_type }
    end
  end
  def create
    @student = User.new(params[:user])
    @student.credits = params[:credits_to_add]
    @student.roles << Role.find_by_name("Student")

    respond_to do |format|
      if @student.save
        format.html { redirect_to students_path, notice: 'Student created successfully.' }
        format.json { render json: @student, status: :created, location: @student }
      else
        format.html { render action: "new" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end
  def index
    @students = Role.find_by_name("Student").users
  end
end
