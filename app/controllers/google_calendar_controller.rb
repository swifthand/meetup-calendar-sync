class GoogleCalendarController < ApplicationController

  def request_auth
    redirect_to credentials.authorization_uri.to_s
  end


  def auth_callback
    credentials.update(params[:code], session)
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
