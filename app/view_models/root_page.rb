class RootPage

  def credentials_exist?
    @credentials ||= GoogleCalendarGateway.build_credentials_store.load_credentials
    @credentials.blank?
  end

end
