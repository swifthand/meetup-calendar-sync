require 'google/api_client'
require 'google/api_client/client_secrets'

module GoogleCalendarGateway

  def self.configure(application_name: , application_version: , oauth2_secrets_file: )
    @api_client   = build_client(application_name, application_version, oauth2_secrets_file)
    @calendar_api = build_calendar(@api_client)
    @configured   = true
  end

  def self.api_client
    ensure_configured!
    @api_client
  end

  def self.calendar_api
    ensure_configured!
    @calendar_api
  end

  def self.build_credentials(redirect_uri, session)
    ensure_configured!
    Credentials.new(redirect_uri, session)
  end

  def self.build_credentials_store
    ensure_configured!
    CredentialsRecordStore.new
    # CredentialsFileStore.new('google_client_secrets.json')
  end

private

  def self.ensure_configured!
    unless configured?
      raise "Google API Client not configured at initialization."
    end
  end

  def self.configured?
    !!@configured
  end

  # Google says that forcing approval prompts every time is a bad idea,
  # and in the sense of the security goals it probably is!
  # However, in the the scope of this application it's the best way
  # to ensure that a lost Refresh Token is recovered without making
  # the setup needlessly frustrating.
  def self.build_client(app_name, app_version, secrets_file)
    client  = Google::APIClient.new(application_name: app_name, application_version: app_version)
    auth    = Google::APIClient::ClientSecrets.load(secrets_file).to_authorization
    auth.authorization_uri      = auth.authorization_uri(approval_prompt: :force)
    client.authorization        = auth
    client.authorization.scope  = 'https://www.googleapis.com/auth/calendar'
    client
  end

  def self.build_calendar(client)
    client.discovered_api('calendar', 'v3')
  end

end
