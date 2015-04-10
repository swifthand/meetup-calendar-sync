MeetupCalendarSync::Application.routes.draw do

  get   'gcal/request_auth',
        :to => 'google_calendar#request_auth',
        :as => 'request_google_auth'
  get   'gcal/auth_callback',
        :to => 'google_calendar#auth_callback',
        :as => 'google_auth_callback'
  get   'gcal',
        :to => 'google_calendar#index',
        :as => 'gcal'
  get   'gcal/edit',
        :to => 'google_calendar#edit',
        :as => 'edit_gcal'
  post  'gcal',
        :to => 'google_calendar#select_gcals',
        :as => 'update_gcal'

  root 'root#index'

end
