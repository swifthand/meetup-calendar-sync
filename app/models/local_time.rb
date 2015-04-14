class LocalTime

  def self.convert(milliseconds)
    Time.at(milliseconds / 1000).in_time_zone(Rails.application.config.time_zone)
  end

end
