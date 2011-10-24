require "test_helper"

class ExporterTest < ActiveSupport::TestCase

  test "should export patient" do
    patient = TestHelper.valid_patient
    csv     = Exporter.new(patient).to_csv

    assert_equal csv, TestHelper.patient_export
  end

end
