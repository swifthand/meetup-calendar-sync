class RootPage

  def credentials_exist?
    @credentials ||= GoogleGateway.build_credentials_store.load_credentials
    !@credentials.blank?
  end

end
