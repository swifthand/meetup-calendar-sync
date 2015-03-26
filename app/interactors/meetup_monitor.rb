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
    EventFreshnessQuery.map_from_events(events).each do |evt, query|
      status, existing_evt = query.call, query.event
      case status
      when :new
        evt.save
      when :fresh
        # Do nothing with an event whose record is still up to date.
      when :outdated
        existing_evt.update_from(evt)
      end
    end
  end

end
