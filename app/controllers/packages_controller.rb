class PackagesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :load_package, :only => [ :show, :edit, :update, :destroy, :destroy_quiz_from_package, :add_quiz_to_package ]
  load_and_authorize_resource :find_by => :slug
  
  # GET /packages
  # GET /packages.json
  def index
    @packages = Package.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @packages }
    end
  end

  # GET /packages/1
  # GET /packages/1.json
  def show
    
    # NOTE: "NOT IN" does not work when it gets an empty array.
    if @package.quizzes.count > 0
      @quizzes = Quiz.where(['quiz_type_id = ? and id NOT IN (?)',QuizType.find_by_name("FullQuiz").id,@package.quizzes.pluck(:quiz_id)])
    else 
      @quizzes = Quiz.where(['quiz_type_id = ?',QuizType.find_by_name('FullQuiz').id])
    end
   
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @package }
    end
  end

  # GET /packages/new
  # GET /packages/new.json
  def new
    @package = Package.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @package }
    end
  end

  # GET /packages/1/edit
  def edit
  end

  # POST /packages
  # POST /packages.json
  def create
    @package = Package.new(params[:package])

    respond_to do |format|
      if @package.save
        format.html { redirect_to @package, notice: 'Package was successfully created.' }
        format.json { render json: @package, status: :created, location: @package }
      else
        format.html { render action: "new" }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /packages/1
  # PUT /packages/1.json
  def update
    respond_to do |format|
      if @package.update_attributes(params[:package])
        format.html { redirect_to @package, notice: 'Package was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.json
  def destroy
    
    @package.destroy

    respond_to do |format|
      format.html { redirect_to packages_url, notice: 'Package was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  
  # /packages/:id/destroy_quiz_from_package/:quiz_id
  # DELETE /packages/:id/destroy_quiz_from_package/:quiz_id.json
  def destroy_quiz_from_package
    begin
      PackageQuiz.delete_all(["package_id = ? AND quiz_id = ?",@package.id,params[:quiz_id]])
      redirect_to @package, notice: 'Quiz was successfully removed from the package.'
    rescue Exception => ex
      logger.info("Error 1001: Error removing quiz from package : " + ex.message)
      redirect_to @package, notice: 'Error 1001: Error removing quiz from the package. '
    end
  end
  
  # /packages/:id/add_quiz_to_package/:quiz_id
  # POST /packages/:id/add_quiz_to_package/:quiz_id.json
  def add_quiz_to_package
    if params[:quiz][:id] == "" || params[:quiz][:id] == nil
      redirect_to @package, notice: 'Please select a quiz to add.'
    else
      package_quiz = PackageQuiz.new
      package_quiz.quiz_id = params[:quiz][:id]
      package_quiz.package_id = @package.id
      if package_quiz.save
        redirect_to @package, notice: 'Quiz added successfully to the package.'
      else
        redirect_to @package, notice: 'Error adding quiz to the package.'
      end
    end
  end
  
  private
  
  def load_package
    @package = Package.find_by_slug!(params[:id])
  end
  
end
