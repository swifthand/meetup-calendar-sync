class ConfiguresOutputGcals

  attr_reader :output_setting, :gcals

  delegate  :errors,
            :to => :output_setting

  def initialize(gcals: [], output_setting: fetch_output_setting)
    @output_setting = output_setting
    @gcals          = gcals
  end


  def apply!
    without_gcals = output_setting.value.reject do |cal|
      cal['service'] == 'google'
    end
    output_setting.update_attributes(value: without_gcals + gcals)
  end


private ########################################################################


  def fetch_output_setting
    OutputCalendarsQuery.as_record
  end

end

