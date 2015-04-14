class OutputCalendar < ImmutableStruct.new(:name, :id, :service, :tags, :access_params)

  def self.default
    calendar_setting = Setting.where(key: 'output_calendars').first
    return nil if calendar_setting.blank?
    default_calendar = calendar_setting.value.find do |cal|
      tags = cal.fetch('tags', [])
      tags.include?('default') || tags.include?('primary')
    end
    return nil if default_calendar.blank?
    new(default_calendar.symbolize_keys)
  end

end
