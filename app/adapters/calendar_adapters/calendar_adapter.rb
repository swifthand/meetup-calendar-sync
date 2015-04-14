module CalendarAdapters
  class CalendarAdapter

    def list(event_dto)
      raise NotConcreteError.new
    end

  end
end
