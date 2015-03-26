class EventFreshnessQuery

## BEGIN: Factories & Batch Factories ##########################################

  class << self
    # Build from an existing event object.
    def from_event(event)
      if event.persisted?
        new(id:             event.meetup_event_id,
            last_update:    event.meetup_last_update,
            existing_event: event)
      else
        new(id: event.meetup_event_id, last_update: event.meetup_last_update)
      end
    end

    # Performs batch lookup for existing events in database,
    # and assigns existing_event from any found therein.
    def from_events(events)
      events    = [*events]
      existing  = fetch_existing_map(events)
      events.map do |evt|
        new(id:             evt.meetup_event_id,
            last_update:    evt.meetup_last_update,
            existing_event: existing.fetch(evt.meetup_event_id, nil))
      end
    end

    # Same as from_events, but returned as a hash which maps from
    # the event given to a query for its information. Again with
    # the existing_event argument assigned via batch lookup.
    def map_from_events(events)
      events    = [*events]
      existing  = fetch_existing_map(events)
      events.each.with_object({}) do |evt, hash|
        hash[evt] = new(
          id:             evt.meetup_event_id,
          last_update:    evt.meetup_last_update,
          existing_event: existing.fetch(evt.meetup_event_id, nil))
      end
    end

    # Fetches existing events, then performs a mapping similar to
    # Enumerable#group_by but which assumes only one record per id.
    def fetch_existing_map(events)
      MeetupEvent
        .where(meetup_event_id: events.map(&:meetup_event_id))
        .to_a
        .each.with_object({}) do |evt, hash|
          hash[evt.meetup_event_id] = evt
        end
    end
  end

## END: Factories & Batch Factories ############################################

  attr_reader :last_update, :id

  def initialize(id: , last_update: , existing_event: nil)
    @id           = id
    @last_update  = last_update
    @event        = existing_event
  end

  def call
    if outdated?
      :outdated
    elsif exists?
      :fresh
    else
      :new
    end
  end

  def event
    @event ||= MeetupEvent.where(meetup_event_id: id).first
  end

private ########################################################################

  def exists?
    event.present?
  end

  def outdated?
    exists? and event.meetup_last_update < last_update
  end

end
