module CalendarAdapters
  class EventDTO < TransactionalDTO
    attribute :source_id
    attribute :destination_id
    attribute :calendar_id
    attribute :start_time
    attribute :end_time
    attribute :all_day

    attribute :name
    attribute :description
    attribute :group
    attribute :source_url
    attribute :destination_url
    attribute :location
    attribute :tags

    attribute :last_update

    attribute :details
  end
end
