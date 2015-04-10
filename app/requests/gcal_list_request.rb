class GcalListRequest

  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end


  def authenticated?
    !auth.expired?
  end


  def calendars
    return :not_authenticated unless authenticated?
    @calendars ||= GoogleCalendarGateway::CalendarListQuery.new(auth: auth).writable
  end

end
