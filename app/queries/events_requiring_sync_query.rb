class EventsRequiringSyncQuery

  def call
    @events ||= MeetupEvent.requires_sync.to_a
  end

end
