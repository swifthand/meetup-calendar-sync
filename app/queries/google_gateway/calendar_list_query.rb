module GoogleGateway
  class CalendarListQuery

    attr_reader :auth

    def initialize(auth)
      @auth = auth
    end

    def call
      @results ||= CalendarAdapter.new(auth).list
    end

    def writable
      call.select(&:write_access)
    end

  end
end
