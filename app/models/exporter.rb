require 'csv'

class Exporter
  def initialize(patient)
    @patient = patient
  end

  def to_csv
    CSV.generate do |csv|
      csv << header("Patient")

      csv << column_names(@patient)
      csv << column_values(@patient)

      csv << header("Procedures")
      add_many(csv, @patient.procedures)

      csv << header("Prescriptions")
      add_many(csv, @patient.prescriptions)

      csv << header("Pre-Meds")
      add_many(csv, @patient.pre_meds)
    end
  end

  private
  def column_names(model)
    model.class.columns.map {|c| c.name}
  end

  def column_values(model)
    column_names(model).map {|cn| model.attributes[cn]}
  end

  def add_many(csv, models)
    if models.empty?
      csv << ["None"]
      return
    end

    csv << column_names(models.first)
    models.each do |p|
      csv << column_values(p)
    end
  end

  def header(name)
    [name]
  end
end