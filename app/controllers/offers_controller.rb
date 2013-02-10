class OffersController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :load_offer, :only => [ :show, :edit, :update, :destroy, :add_quiz_to_offer, :add_package_to_offer, :destroy_quiz_from_offer, :add_emails_to_offer, :destroy_email_from_offer ]
  load_and_authorize_resource
  
  # GET /offers
  # GET /offers.json
  def index
    @offers = Offer.all
    @offer_codes = OfferCode.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offers }
    end
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
    @offer = Offer.find(params[:id])
    @offer_quizzes = @offer.quizzes
    @offer_packages = @offer.packages
    @quizzes = Quiz.excluding(@offer.quizzes)
    @packages = Package.excluding(@offer.packages)
    @offer_users = @offer.offer_users

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offer }
    end
  end

  # GET /offers/new
  # GET /offers/new.json
  def new
    @offer = Offer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @offer }
    end
  end

  # GET /offers/1/edit
  def edit
    @offer = Offer.find(params[:id])
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = Offer.new(params[:offer])

    respond_to do |format|
      if @offer.save
        format.html { redirect_to @offer, notice: 'Offer was successfully created.' }
        format.json { render json: @offer, status: :created, location: @offer }
      else
        format.html { render action: "new" }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /offers/1
  # PUT /offers/1.json
  def update
    @offer = Offer.find(params[:id])

    respond_to do |format|
      if @offer.update_attributes(params[:offer])
        format.html { redirect_to @offer, notice: 'Offer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @offer = Offer.find(params[:id])
    @offer.destroy

    respond_to do |format|
      format.html { redirect_to offers_url }
      format.json { head :no_content }
    end
  end
  
  # /offers/:id/add_quiz_to_offer/:quiz_id
  # POST /offers/:id/add_quiz_to_offer/:quiz_id.json
  def add_quiz_to_offer
    if params[:quiz][:id] == "" || params[:quiz][:id] == nil
      redirect_to @offer, notice: 'Please select a quiz to add.'
    else
      offer_quiz = OfferItem.new
      offer_quiz.quiz_id = params[:quiz][:id]
      offer_quiz.offer_id = @offer.id
      if offer_quiz.save
        redirect_to @offer, notice: 'Quiz added successfully to the offer.'
      else
        redirect_to @offer, notice: 'Error adding quiz to the offer.'
      end
    end
  end
  
  # /offers/:id/add_quiz_to_offer/:quiz_id
  # POST /offers/:id/add_quiz_to_offer/:quiz_id.json
  def add_package_to_offer
    if params[:package][:id] == "" || params[:package][:id] == nil
      redirect_to @offer, notice: 'Please select a package to add.'
    else
      offer_package = OfferItem.new
      offer_package.package_id = params[:package][:id]
      offer_package.offer_id = @offer.id
      if offer_package.save
        redirect_to @offer, notice: 'Package added successfully to the offer.'
      else
        redirect_to @offer, notice: 'Error adding package to the offer.'
      end
    end
  end
  
  # /packages/:id/destroy_quiz_from_package/:quiz_id
  # DELETE /packages/:id/destroy_quiz_from_package/:quiz_id.json
  def destroy_quiz_from_offer
    begin
      OfferItem.delete_all(["offer_id = ? AND quiz_id = ?",@offer.id,params[:quiz_id]])
      redirect_to @offer, notice: 'Quiz was successfully removed from the offer.'
    rescue Exception => ex
      logger.info("Error 1001: Error removing quiz from offer : " + ex.message)
      redirect_to @offer, notice: 'Error 1001: Error removing quiz from the offer. '
    end
  end
  
  # /packages/:id/destroy_quiz_from_package/:quiz_id
  # DELETE /packages/:id/destroy_quiz_from_package/:quiz_id.json
  def destroy_package_from_offer
    begin
      OfferItem.delete_all(["offer_id = ? AND package_id = ?",@offer.id,params[:package_id]])
      redirect_to @offer, notice: 'Package was successfully removed from the offer.'
    rescue Exception => ex
      logger.info("Error 1001: Error removing package from offer : " + ex.message)
      redirect_to @offer, notice: 'Error 1001: Error removing package from the offer. '
    end
  end
  
  # /offers/:id/add_emails_to_offer
  # POST /offers/:id/add_emails_to_offer
  def add_emails_to_offer
    
    if params[:emails] == nil || params[:emails].strip == ""
      redirect_to @offer, notice: 'Please enter atleast one email.'
    else
      emails = params[:emails].strip.split("\r\n")
      
      begin
        emails.each do |email|
        
          offer_user = OfferUser.new
          offer_user.offer_id = params[:id]
          offer_user.email = email.strip
          offer_user.save
        
        end
        
        redirect_to @offer, notice: 'Emails added successfully to the offer.'
        
      rescue Exception => ex
        logger.info("Error adding emails to the offer: " + ex.message )
        redirect_to @offer, notice: 'Error adding emails to the offer.'
      end

    end
  end
  
  # /offers/:id/destroy_email_from_offer
  # DELETE /offers/:id/destroy_email_from_offer
  def destroy_email_from_offer
    begin
      logger.info("params[email] = " + params[:email])
      OfferUser.delete_all(["offer_id = ? AND email = ?",@offer.id,params[:email]])
      redirect_to @offer, notice: 'Email was successfully removed from the offer.'
    rescue Exception => ex
      logger.info("Error 1001: Error removing email from offer : " + ex.message)
      redirect_to @offer, notice: 'Error 1001: Error removing email from the offer. '
    end
  end
  
  private
  
  def load_offer
    @offer = Offer.find(params[:id])
  end
  
end
