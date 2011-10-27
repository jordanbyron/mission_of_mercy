class PatientPreviousMomClinic < ActiveRecord::Base
  CLINICS = {2010 => "Middletown", 2009 => "New Haven", 2008 => "Tolland"}

  after_save :destroy_unless_attended

  def description
    if clinic_year
      [clinic_year, location].join(" ")
    else
      location
    end
  end

  private

  def destroy_unless_attended
    destroy unless attended
  end
end
