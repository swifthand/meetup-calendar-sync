module CalendarAdapters
  class CalendarDTO < TransactionalDTO
    attribute :id
    attribute :summary
    attribute :description
    attribute :read_access
    attribute :write_access
    attribute :admin_access
  end
end
