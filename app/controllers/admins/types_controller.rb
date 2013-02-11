module Admins
  class TypesController < ApplicationController
  
    before_filter :authenticate_user!
    before_filter :load_type, :only => [ :show, :edit, :update, :destroy ]
    load_and_authorize_resource :find_by => :slug
  
    # GET /types
    # GET /types.json
    def index
      @types = Type.order(:name).all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @types }
      end
    end
  
    # GET /types/1
    # GET /types/1.json
    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @type }
      end
    end
  
    # GET /types/new
    # GET /types/new.json
    def new
      @type = Type.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @type }
      end
    end
  
    # GET /types/1/edit
    def edit
    end
  
    # POST /types
    # POST /types.json
    def create
      @type = Type.new(params[:type])
  
      respond_to do |format|
        if @type.save
          format.html { redirect_to [:admins,@type], notice: 'Type was successfully created.' }
          format.json { render json: @type, status: :created, location: @type }
        else
          format.html { render action: "new" }
          format.json { render json: @type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /types/1
    # PUT /types/1.json
    def update
      respond_to do |format|
        if @type.update_attributes(params[:type])
          format.html { redirect_to [:admins,@type], notice: 'Type was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /types/1
    # DELETE /types/1.json
    def destroy
      
      @type.destroy
  
      respond_to do |format|
        format.html { redirect_to admins_types_url, notice: 'Type was successfully deleted.' }
        format.json { head :no_content }
      end
    end
    
    private
    
    def load_type
      @type = Type.find_by_slug!(params[:id])
    end
    
  end
end