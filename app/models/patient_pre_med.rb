class PatientPreMed < ActiveRecord::Base
  after_save :destroy_unless_prescribed
  
  belongs_to :pre_med
  belongs_to :patient
  
  private
  
  def destroy_unless_prescribed
    destroy unless prescribed
  end
end
