module GoogleGateway
  class CalendarsController < ApplicationController


  def index
    request = CalendarListRequest.new(credentials.auth)
    if request.authenticated?
      @page   = CalendarListPage.new(discovered_calendars: request.calendars)
      render 'list_page'
    else
      render 'authorization_required'
    end
  end


  def edit
    request = CalendarListRequest.new(credentials.auth)
    if request.authenticated?
      @page   = CalendarListPage.new(discovered_calendars: request.calendars)
      render 'edit'
    else
      render 'authorization_required'
    end
  end


  def update
    request = ConfigureOutputCalendarsRequest.new(params[:google_calendars])
    if ConfiguresOutputCalendars.new(calendars: request.selected_calendars).apply!
      redirect_to(google_calendars_path)
    else
      redirect_to(edit_google_calendars_path)
    end
  end


private ########################################################################

    def credentials
      @credentials ||= GoogleGateway.build_credentials
    end

  end
end
