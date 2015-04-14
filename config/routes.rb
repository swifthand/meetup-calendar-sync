MeetupCalendarSync::Application.routes.draw do

  scope :module => 'google_gateway' do
    get 'google/request_auth',
        :to => 'authorizations#create',
        :as => 'request_google_auth'
    get 'google/auth_callback',
        :to => 'authorizations#callback',
        :as => 'google_auth_callback'

    get   'google/calendars',
          :to => 'calendars#index',
          :as => 'google_calendars'
    get   'google/calendars/edit',
          :to => 'calendars#edit',
          :as => 'edit_google_calendars'
    post  'google/calendars',
          :to => 'calendars#update',
          :as => 'update_google_calendars'
  end

  root 'root#index'

end
