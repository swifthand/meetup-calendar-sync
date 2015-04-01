GoogleCalendarGateway.configure(
  application_name:     'Meetup Calendar Sync',
  application_version:  '0.0.1',
  oauth2_secrets_file:  'config/google_client_secrets.json'
)

module Calendar

  def self.event_adapter
    @event_adapter ||= GoogleCalendarGateway::EventAdapter
  end

end
