class LocalTime

  def self.convert(milliseconds)
    Time.at(milliseconds / 1000)
  end

end
