class GoogleCalendarController < ApplicationController

  def request_auth
    redirect_to credentials.authorization_uri
  end


  def auth_callback
    credentials.update_from_code(params[:code])
  end


  def index
    request = GcalListRequest.new(credentials.auth)
    if request.authenticated?
      @page   = GcalListPage.new(discovered_calendars: request.calendars)
      render 'list_page'
    else
      render 'requires_auth'
    end
  end


  def edit
    request = GcalListRequest.new(credentials.auth)
    if request.authenticated?
      @page   = GcalListPage.new(discovered_calendars: request.calendars)
      render 'edit'
    else
      render 'requires_auth'
    end
  end


  def update
    request = ConfigureOutputGcalsRequest.new(params[:gcals])
    if ConfiguresOutputGcals.new(gcals: request.selected_calendars).apply!
      redirect_to(gcal_path)
    else
      redirect_to(edit_gcal_path)
    end
  end


private

  def credentials
    @credentials ||= GoogleCalendarGateway.build_credentials
  end

end
