MeetupCalendarSync::Application.routes.draw do

  get 'gcal/request_auth',
      :to => 'google_calendar#request_auth',
      :as => 'request_google_auth'
  get 'gcal/auth_callback',
      :to => 'google_calendar#auth_callback',
      :as => 'google_auth_callback'

  root 'root#index'

end
