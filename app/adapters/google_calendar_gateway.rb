require 'google/api_client'
require 'google/api_client/client_secrets'

module GoogleCalendarGateway

  def self.configure( application_name: , application_version: , oauth2_secrets_file: ,
                      credentials_storage: :database, credentials_key: nil, credentials_path: nil,
                      default_redirect_uri: )
    @api_client   = build_client(application_name, application_version, oauth2_secrets_file)
    @calendar_api = build_calendar(@api_client)
    @oauth2_secrets_file  = oauth2_secrets_file
    @credentials_source   = determine_credentials_source(credentials_storage, credentials_key, credentials_path)
    @configured           = true
    @default_redirect_uri = default_redirect_uri
  end


  def self.execute(*args)
    ensure_configured!
    api_client.execute(*args)
  end


  def self.calendar_api
    ensure_configured!
    @calendar_api
  end


  def self.build_credentials(redirect_uri = default_redirect_uri, from_hash: false)
    ensure_configured!
    Credentials.new(
      auth:         api_client.authorization.dup,
      redirect_uri: redirect_uri,
      from_hash:    from_hash,
      store:        build_credentials_store)
  end


  def self.build_credentials_store
    ensure_configured!
    credentials_source[:store].new(credentials_source[:location])
  end


  def self.default_redirect_uri
    ensure_configured!
    @default_redirect_uri
  end


private ########################################################################


  def self.ensure_configured!
    unless configured?
      raise "Google API Client not configured at initialization."
    end
  end


  def self.configured?
    !!@configured
  end


  def self.determine_credentials_source(storage, key, path)
    case storage
    when :record, :database
      path = CredentialsRecordStore::DEFAULT_KEY if key.blank?
      { store: CredentialsRecordStore,
        location: key
      }
    when :file, :file_system
      path = CredentialsFileStore::DEFAULT_PATH if path.blank?
      { store: CredentialsFileStore,
        location: path
      }
    else
      { store:    CredentialsRecordStore,
        location: CredentialsRecordStore::DEFAULT_KEY
      }
    end
  end


  def self.credentials_source
    @credentials_source
  end


  def self.api_client
    @api_client
  end


  def self.oauth2_secrets_file
    @oauth2_secrets_file
  end

  # Google says that forcing approval prompts every time is a bad idea,
  # and in the sense of the usual OAuth security goals it probably is!
  # However, in the the scope of this application it's the best way
  # to ensure that a lost Refresh Token is recovered without making
  # the setup needlessly frustrating.
  def self.build_client(app_name, app_version, secrets_file)
    client  = Google::APIClient.new(
      application_name:     app_name,
      application_version:  app_version,
      auto_refresh_token:   true)
    auth = Google::APIClient::ClientSecrets.load(secrets_file).to_authorization
    auth.authorization_uri      = auth.authorization_uri(approval_prompt: :force)
    client.authorization        = auth
    client.authorization.scope  = 'https://www.googleapis.com/auth/calendar'
    client
  end


  def self.build_calendar(client)
    client.discovered_api('calendar', 'v3')
  end

end
