module GoogleCalendarGateway
  # Currently the FileStore works just the way we need it to.
  CredentialsFileStore = ::Google::APIClient::FileStore
  CredentialsFileStore::DEFAULT_PATH = 'config/google_client_refresh.json'
end
