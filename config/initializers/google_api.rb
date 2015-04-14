Rails.application.config.after_initialize do
  Rails.application.reload_routes!
  redirect_uri =  Rails.application.routes.url_helpers.google_auth_callback_url
  GoogleGateway.configure(
    application_name:     'Meetup Calendar Sync',
    application_version:  '0.0.2',
    oauth2_secrets_file:  'config/google_client_secrets.json',
    default_redirect_uri: redirect_uri
  )
end
