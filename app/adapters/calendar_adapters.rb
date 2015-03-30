module CalendarAdapters

  class NotConcreteError < StandardError
    NOT_CONCRETE = "This must be called by a specific calendar adapter implementation."
    def initlialize(msg = NOT_CONCRETE)
      super(msg)
    end
  end

end
