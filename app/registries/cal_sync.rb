module CalSync
  include ActsAsRegistry # Override helpers for test env.

  def self.meetup_client
    @meetup_client ||= RubyMeetup::ApiKeyClient
  end

  def self.event_publishing_adapter
    @event_adapter ||= GoogleGateway::EventAdapter
  end

  def self.build_event_publishing_adapter
    GoogleGateway::EventAdapter.new(auth: GoogleGateway.build_credentials.auth)
  end

  def self.meetup_query_rate
    @meetup_query_rate ||= [2, per: 0.5]
  end

  def self.google_query_rate
    @google_query_rate ||= [2, per: 0.5]
  end

  def self.default_output_calendar
    @default_output_calendar ||= OutputCalendar.default
  end

end
