require "test_helper"

class PatientTest < ActiveSupport::TestCase

  def test_should_not_allow_more_than_2_digits_in_state_field
    patient = Factory.build(:patient, :state => "CTZ")

    patient.save

    assert patient.errors[:state].any?

    patient.state = "CT"

    patient.save

    assert patient.errors[:state].none?
  end

  def test_should_not_allow_more_than_10_digits_in_zip_field
    patient = Factory.build(:patient, :zip => "1234567890!")

    patient.save

    assert patient.errors[:zip].any?,
           "More than 10 digits allowed for zip"

    patient.zip = "1234567890"

    patient.save

    assert patient.errors[:zip].none?,
           "10 or less digits are causing validation problems"
  end

  def test_time_in_pain_should_set_the_pain_length_in_days_attribute
    valid_formats = {
      "12d"      => 12,
      "1m"       => 30,
      "45 weeks" => 315,
      "1 year"   => 365,
      "4 Months"  => 120,
      "1W   "     => 7,
      "6Months"   => 180,
      "0days"     => 0,
      "03w"       => 21,
      "1.5months" => 30,
      "0.5days"   => 1,
      ".9 Months" => 0
    }

    patient = TestHelper.valid_patient

    valid_formats.each do |format, result|
      patient.time_in_pain = format

      assert patient.save, "Couldn't save Patient with time_in_pain value = #{ format }"

      assert_equal result, patient.pain_length_in_days
    end
  end

  def test_invalid_time_in_pain_values_should_cause_validation_errors
    invalid_formats = ["12dd", "1.5.1m", "45 weeks months", "about a year",
      "15 minutes", "aaa", "123z"]

    patient = TestHelper.valid_patient

    invalid_formats.each do |format|
      patient.time_in_pain = format

      assert !patient.save, "Patient was saved with time_in_pain format = #{ format }"

      assert patient.errors[:time_in_pain].any?, "#{format} is not a valid format"
    end
  end

  def test_time_in_pain_validations_should_only_be_run_if_time_in_pain_is_set
    patient = TestHelper.valid_patient

    assert patient.save

    assert patient.errors[:time_in_pain].none?
  end

  def test_travel_time_is_calculated
    patient = TestHelper.valid_patient

    patient.travel_time_minutes = 15

    assert_equal 15, patient.travel_time_minutes

    assert_equal 15, patient.travel_time

    assert patient.save

    patient.travel_time_hours = "1"

    assert_equal 1, patient.travel_time_hours

    assert_equal 75, patient.travel_time

    assert patient.save
  end

  def test_text_entry_for_date_of_birth_should_accept_reasonable_date_formats
    valid_formats = {
      "05/23/2008"    => Date.civil(2008, 5, 23),
      "05-23-2008"    => Date.civil(2008, 5, 23),
      "05.23.2008"    => Date.civil(2008, 5, 23),
    }

    patient = TestHelper.valid_patient

    valid_formats.each do |format, result|
      patient.date_of_birth = format

      assert patient.save, "Couldn't save Patient with date_of_birth value = #{ format }"

      assert_equal result, patient.date_of_birth
    end
  end

  def test_text_entry_for_date_of_birth_should_not_accept_invalid_date_formats
    patient = TestHelper.valid_patient

    patient.date_of_birth = "23/1/1"

    assert !patient.save,
      "Saved patient with an invalid date_of_birth value"
  end

  def test_shoould_properly_assign_treatment_area
    patient = Factory(:patient)
    area = Factory(:treatment_area)

    patient.assign(area.id, false)
    
    assert_equal 1, patient.assignments.count
    assert_equal area, patient.assignments[0].treatment_area
  end

  def test_should_return_area_to_which_patient_is_assigned
    patient = Factory(:patient)
    area = Factory(:treatment_area)

    patient.assign(area.id, :do_not_assign_to_radiology)

    assert_equal area, patient.assigned_to[0]
  end

  def test_shoud_allow_for_assigning_to_multiple_areas
    patient = Factory(:patient)
    area = Factory(:treatment_area)
    area_radiology = Factory(:treatment_area, name: TreatmentArea::RADIOLOGY_NAME)

    patient.assign(area.id, true)

    assert_equal [area, area_radiology], patient.assigned_to 
  end

  def test_shoud_allow_for_assigning_to_radiology_only
    patient = Factory(:patient)
    area_radiology = Factory(:treatment_area, name: TreatmentArea::RADIOLOGY_NAME)

    patient.assign(nil, true)

    assert_equal [area_radiology], patient.assigned_to 
  end

  def test_should_allow_check_out
    area = Factory(:treatment_area)
    patient = Factory(:patient)

    patient.assign(area, false)
    assert_equal area, patient.assigned_to[0]

    patient.check_out(area)
    assert patient.assigned_to.empty?
  end

  def test_should_save_check_out_time
    area = Factory(:treatment_area)
    patient = Factory(:patient)

    assert patient.assign(area, false)
    assert_nil patient.assignments.last.checked_out_at

    patient.check_out(area)
    assert_not_nil patient.assignments.last.checked_out_at
  end

  def test_should_return_false_if_assignment_wasnt_successfull
    patient = Factory(:patient)
    assert_equal false, patient.assign(nil, false)
  end

end
