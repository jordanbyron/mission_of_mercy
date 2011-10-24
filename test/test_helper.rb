ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module TestHelper
  extend self
  
  # December, 26, 1985
  def clinic_date(time=nil)
    date = "12/26/1985"
    
    if time
      m, d, y = date.split('/')
      Time.parse "#{[y, m, d] * '-'} #{time}"
    else
      Date.strptime(date, "%m/%d/%Y")
    end    
  end
  
  def valid_patient
    patient = Patient.new(
        :first_name        => "Jordan",
        :last_name         => "Byron",
        :date_of_birth     => Date.civil(1985, 12, 26),
        :sex               => "M",
        :race              => "AMERICAN",
        :chief_complaint   => "Too Amazing",
        :last_dental_visit => "Today",
        :travel_time       => 1,
        :city              => "Naugatuck",
        :state             => "CT")

    oral_procedure = Procedure.new(
        :code        => 150,
        :description => "Oral Exam",
        :cost        => 90
    )

    film_procedure = Procedure.new(
        :code        => 330,
        :description => "Film",
        :cost        => 125
    )

    patient.procedures << oral_procedure
    patient.procedures << film_procedure
    patient
  end

  def patient_export
    File.open("test/export_files/patient.csv", "r").read
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
