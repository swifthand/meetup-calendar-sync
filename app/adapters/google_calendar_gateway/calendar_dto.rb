module GoogleCalendarGateway
  class CalendarDTO < ::CalendarAdapters::TransactionalDTO
    attribute :id
    attribute :summary
    attribute :description
    attribute :access_role
  end
end
