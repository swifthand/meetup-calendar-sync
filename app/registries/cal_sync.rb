module CalSync

  def self.meetup_client
    @meetup_client ||= RubyMeetup::ApiKeyClient
  end

  def self.request_delay
    @request_delay ||= 0.5
  end

  def self.requests_per_delay
    @requests_per_delay ||= 5
  end

  def self.output_event_adapter
    @event_adapter ||= GoogleCalendarGateway::EventAdapter
  end

end
