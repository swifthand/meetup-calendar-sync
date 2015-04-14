module GoogleGateway
  class CalendarListRequest

    attr_reader :auth

    def initialize(auth)
      @auth = auth
    end


    def authenticated?
      auth.access_token.present? and !auth.expired?
    rescue ArgumentError
      auth.refresh!
      retry
    end


    def calendars
      return :not_authenticated unless authenticated?
      @calendars ||= GoogleGateway::CalendarListQuery.new(auth: auth).writable
    end

  end
end
