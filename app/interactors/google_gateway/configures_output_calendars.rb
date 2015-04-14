module GoogleGateway
  class ConfiguresOutputCalendars

    attr_reader :output_setting, :calendars

    delegate  :errors,
              :to => :output_setting

    def initialize(calendars: [], output_setting: fetch_output_setting)
      @output_setting = output_setting
      @calendars      = calendars
    end


    def apply!
      without_cals = output_setting.value.reject do |cal|
        cal['service'] == 'google'
      end
      output_setting.update_attributes(value: without_cals + calendars)
    end


  private ########################################################################


    def fetch_output_setting
      OutputCalendarsQuery.as_record
    end

  end
end
