class OutputCalendarsQuery

  def self.call
    record = as_record
    if record.blank? or record.value.blank?
      []
    else
      record.value
    end
  end

  def self.as_record
    record = Setting.where(key: 'output_calendars').first_or_initialize
    record.value = [] if record.new_record?
    record
  end

end
