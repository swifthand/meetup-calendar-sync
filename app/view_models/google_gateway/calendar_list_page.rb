module GoogleGateway
  class CalendarListPage

    attr_reader :discovered_calendars

    def initialize(discovered_calendars: [])
      @discovered_calendars = discovered_calendars
    end


    def selected_calendars
      @selected_calendars ||= OutputCalendarsQuery.call.select do |cal|
        cal['service'] == 'google'
      end
    end


    def selected_calendar_ids
      @selected_calendar_ids ||= selected_calendars.map { |cal| cal['id'] }
    end


    def selected?(gcal)
      selected_calendar_ids.include?(gcal.id)
    end


    def tag_text_for(gcal)
      return "" unless selected?(gcal)
      selected_calendars.find do |cal|
        cal['id'] == gcal['id']
      end['tags'].join(", ")
    end

  end
end
