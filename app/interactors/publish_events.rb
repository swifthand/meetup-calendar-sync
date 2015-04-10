class PublishEvents

  attr_reader :event_adapter

  def initialize(output_event_adapter: CalSync.output_event_adapter)
    @event_adapter ||= event_adapter.new
  end


  def apply
    publish
  end


  def source_event_ids
    @source_event_ids ||= source_events.keys
  end


  def source_events
    @source_events ||= EventsRequiringSyncQuery.new.call.hash_by(:id)
  end


  def published_events
    PublishedEventsQuery.new(source_id: source_event_ids).call.hash_by(:source_id)
  end


  def previously_published?(source_event)
    published_events.key?(source_event.id)
  end


private ########################################################################


  def publish
    source_events.map.rate_limit(2, per: 0.5) do |src_id, src_evt|
      if previously_published?(src_evt)
        event_adapter.update(dto_for_update(src_evt, published_events[src_evt.id]))
      else
        event_adapter.create(dto_for_create(src_evt))
      end
    end
  end


  def dto_for_update(source, published)
    CalendarAdapters::EventDTO.request(
      id:           published.destination_id,
      calendar_id:  published.calendar_id,
      start_time:   source.start_time,
      end_time:     source.end_time,
      name:         source.name,
      description:  source.description,
      group:        source.group_name,
      url:          source.url,
      location:     source.location,
      tags:         source.tags,
      last_update:  source.last_update
    )
  end


  def dto_for_create(source)
    CalendarAdapters::EventDTO.request(
      start_time:   source.start_time,
      end_time:     source.end_time,
      name:         source.name,
      description:  source.description,
      group:        source.group_name,
      url:          source.url,
      location:     source.location,
      tags:         source.tags,
      last_update:  source.last_update
    )
  end

end
