require 'google/api_client'
require 'google/api_client/client_secrets'

module GoogleCalendarGateway

  def self.configure(application_name: , application_version: , oauth2_secrets_file: )
    @api_client   = build_client(application_name, application_version, oauth2_secrets_file)
    @calendar_api = build_calendar(@api_client)
    @client_auth
  end

  def self.api_client
    @api_client
  end

  def self.calendar_api
    @calendar_api
  end

  def self.client_auth
    @client_auth ||= build_client_auth
  end

private

  def self.build_client(app_name, app_version, secrets_file)
    client = Google::APIClient.new(
      application_name:     app_name,
      application_version:  app_version)
    client_secrets = Google::APIClient::ClientSecrets.load(secrets_file)
    client.authorization = client_secrets.to_authorization
    client.authorization.scope = 'https://www.googleapis.com/auth/calendar'
    client
  end

  def self.build_calendar(client)
    client.discovered_api('calendar', 'v3')
  end

  def self.build_client_auth
    auth = api_client.authorization.dup
    auth.redirect_uri = to('/oauth2callback')
    auth.update_token!(session)
    auth
  end

end
