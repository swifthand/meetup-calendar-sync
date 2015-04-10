module CalendarAdapters
  class EventDTO < TransactionalDTO
    attribute :id
    attribute :calendar_id
    attribute :start_time
    attribute :end_time

    attribute :name
    attribute :description
    attribute :group
    attribute :url
    attribute :location
    attribute :tags

    attribute :last_update
  end
end
