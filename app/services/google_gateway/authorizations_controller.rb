
module GoogleGateway
  class AuthorizationsController < ApplicationController

    def create
      redirect_to credentials.authorization_uri
    end

    def callback
      credentials.update_from_code(params[:code])
      redirect_to google_calendars_path
    rescue Signet::AuthorizationError => exc
      render 'oauth_error'
    end

private ########################################################################

    def credentials
      @credentials ||= GoogleGateway.build_credentials
    end

  end
end
