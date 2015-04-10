module GoogleCalendarGateway
  class CalendarListQuery

    attr_reader :auth

    def initialize(auth)
      @auth = auth
    end

    def call
      @results ||= CalendarAdapter.new(auth).list
    end

    def writable
      call.select { |cal| cal.access_role == 'owner' or cal.access_role == 'writer' }
    end

  end
end
