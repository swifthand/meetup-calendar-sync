class MeetupMonitor

  attr_reader :meetup_client, :results

  def initialize(meetup_client: CalSync.meetup_client.new)
    @meetup_client  = meetup_client
    @results        = false
  end

  def apply
    persist_changes(fetch_events)
  end


private ########################################################################


  def fetch_events
    UpcomingEventsQuery.call(client: meetup_client)
  end


  def persist_changes(events)
    events.each do |evt|
      existing = existing_and_outdated(evt)
      if existing == nil
        evt.save
      else
        existing.update_from(evt)
      end
    end
  end


  def existing_and_outdated
    MeetupEvent
    .where(meetup_event_id: evt.meetup_event_id)
    .where("meetup_last_update < :last_update", last_update: evt.meetup_last_update)
    .first
  end

end
