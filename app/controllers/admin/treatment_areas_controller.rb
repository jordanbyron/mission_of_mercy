class Admin::TreatmentAreasController < ApplicationController
  before_filter :admin_required
  before_filter :setup_procedures, :only => [:new, :edit]
  before_filter :find_treatment_area, :only => [:show, :update, :destroy]
  before_filter :set_current_tab

  def index
    @treatment_areas = TreatmentArea.all
  end

  def show

  end

  def new

  end

  def create
    @treatment_area = TreatmentArea.new(params[:treatment_area])

    if @treatment_area.save
      redirect_to admin_treatment_areas_path
    else
      render :action => :new
    end
  end

  def edit

  end

  def update
    @treatment_area.attributes = params[:treatment_area]

    @treatment_area.procedure_treatment_area_mappings.each do |p|
      p.destroy if !p.new_record? && p.assigned == "0"
    end

    if @treatment_area.save
      flash[:notice] = 'Treatment Area was successfully updated.'
      redirect_to admin_treatment_areas_path
    else
      render :action => :edit
    end
  end

  def destroy
    @treatment_area.destroy
    redirect_to admin_treatment_areas_path
  end

  private

  def find_treatment_area
    @treatment_area = TreatmentArea.find(params[:id])
  end

  def setup_procedures
    if params[:id]
      @treatment_area = TreatmentArea.find(params[:id])
    else
      @treatment_area = TreatmentArea.new
    end

    @treatment_area.procedure_treatment_area_mappings.each do |p|
      p.assigned = true
    end

    Procedure.all.each do |pro|
      unless @treatment_area.procedures.exists? pro
        @treatment_area.procedure_treatment_area_mappings.build(:procedure_id => pro.id)
      end
    end
  end

  def set_current_tab
    @current_tab = "treatment-areas"
  end
end
