module Admins
  class OfferCodesController < ApplicationController
    
    before_filter :authenticate_user!
    before_filter :load_offer_code, :only => [ :show, :edit, :update, :destroy ]
    load_and_authorize_resource
    
    # GET /offers
    # GET /offers.json
    def index
      @offer_codes = OfferCode.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @offer_codes }
      end
    end
  
    # GET /offers/1
    # GET /offers/1.json
    def show
      @offer_code = OfferCode.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @offer_code }
      end
    end
  
    # GET /offers/new
    # GET /offers/new.json
    def new
      @offer_code = OfferCode.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @offer_code}
      end
    end
  
    # GET /offers/1/edit
    def edit
      @offer_code = OfferCode.find(params[:id])
    end
  
    # POST /offers
    # POST /offers.json
    def create
      @offer_code = OfferCode.new(params[:offer_code])
  
      respond_to do |format|
        if @offer_code.save
          @offer_codes = OfferCode.all
          @offers = Offer.all
          format.html { redirect_to admins_offers_url, notice: 'Offer code was successfully created.' }
          format.json { render json: @offer_code, status: :created, location: @offer_code }
        else
          format.html { render action: "new" }
          format.json { render json: @offer_code.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /offers/1
    # PUT /offers/1.json
    def update
      @offer_code = OfferCode.find(params[:id])
  
      respond_to do |format|
        if @offer_code.update_attributes(params[:offer_code])
          @offer_codes = OfferCode.all
          @offers = Offer.all
          format.html { redirect_to admins_offers_url, notice: 'Offer code was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @offer_code.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /offers/1
    # DELETE /offers/1.json
    def destroy
      @offer_code = OfferCode.find(params[:id])
      @offer_code.destroy
  
      respond_to do |format|
        format.html { redirect_to admins_offers_url }
        format.json { head :no_content }
      end
    end
    
    private
    
    def load_offer_code
      @offer_code = OfferCode.find(params[:id])
    end
    
  end
end