module Admins
  class SectionTypesController < ApplicationController
    
    before_filter :authenticate_user!
    before_filter :load_section_type, :only => [ :show, :edit, :update, :destroy ]
    load_and_authorize_resource :find_by => :slug
    
    # GET /section_types
    # GET /section_types.json
    def index
      @section_types = SectionType.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @section_types }
      end
    end
  
    # GET /section_types/1
    # GET /section_types/1.json
    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @section_type }
      end
    end
  
    # GET /section_types/new
    # GET /section_types/new.json
    def new
      @section_type = SectionType.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @section_type }
      end
    end
  
    # GET /section_types/1/edit
    def edit
    end
  
    # POST /section_types
    # POST /section_types.json
    def create
      @section_type = SectionType.new(params[:section_type])
  
      respond_to do |format|
        if @section_type.save
          format.html { redirect_to [:admins, @section_type], notice: 'Section type was successfully created.' }
          format.json { render json: @section_type, status: :created, location: @section_type }
        else
          format.html { render action: "new" }
          format.json { render json: @section_type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /section_types/1
    # PUT /section_types/1.json
    def update
      respond_to do |format|
        if @section_type.update_attributes(params[:section_type])
          format.html { redirect_to [:admins, @section_type], notice: 'Section type was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @section_type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /section_types/1
    # DELETE /section_types/1.json
    def destroy
      
      @section_type.destroy
  
      respond_to do |format|
        format.html { redirect_to admins_section_types_url, notice: 'Section type was successfully deleted.' }
        format.json { head :no_content }
      end
    end
    
    private
    
    def load_section_type
      @section_type = SectionType.find_by_slug!(params[:id])
    end
    
  end
end