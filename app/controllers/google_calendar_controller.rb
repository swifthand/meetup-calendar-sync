class GoogleCalendarController < ApplicationController

  def request_auth
    ap credentials
    ap credentials.authorization_uri.to_s
    redirect_to credentials.authorization_uri.to_s
  end


  def auth_callback
    credentials.code = params[:code]
    credentials.fetch_access_token!
    GoogleCalendarGateway.store_credentials(credentials, session)
  end


  def index

  end


private

  def credentials
    @credentials ||= GoogleCalendarGateway.build_credentials(
      url_for(controller: 'google_calendar', action: 'auth_callback'),
      session
    )
  end

end
