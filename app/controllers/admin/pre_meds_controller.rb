class Admin::PreMedsController < ApplicationController
  before_filter :admin_required
  before_filter :find_pre_med, :only => [:edit, :update, :destroy, :show]
  before_filter :set_current_tab

  def index
    @pre_meds = PreMed.all
  end

  def new
    @pre_med = PreMed.new
  end

  def edit

  end

  def create
    @pre_med = PreMed.new(params[:pre_med])

    if @pre_med.save
      flash[:notice] = 'PreMed was successfully created.'
      redirect_to admin_pre_meds_path
    else
      render :action => "new"
    end
  end

  def update

    if @pre_med.update_attributes(params[:pre_med])
      flash[:notice] = 'PreMed was successfully updated.'
      redirect_to admin_pre_meds_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @pre_med.destroy

    redirect_to admin_pre_meds_path
  end

  private

  def find_pre_med
    @pre_med = PreMed.find(params[:id])
  end

  def set_current_tab
    @current_tab = "pre-meds"
  end
end
