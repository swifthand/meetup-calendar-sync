module CalendarAdapters
  class EventAdapter

    def create(event_dto)
      raise NotConcreteError.new
    end

    def update(event_dto)
      raise NotConcreteError.new
    end

  end
end
