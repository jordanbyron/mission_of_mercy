class PatientAssignment < ActiveRecord::Base

  belongs_to :patient
  belongs_to :treatment_area

  scope :not_checked_out, where('checked_out_at IS NULL')

  def check_out
    update_attributes(checked_out_at: Time.new)
  end

  def radiology?
    treatment_area.radiology?
  end

end
