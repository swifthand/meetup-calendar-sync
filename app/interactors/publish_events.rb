class PublishEvents

  attr_reader :event_publishing_adapter, :successes, :failures, :publishing_record,
              :published_events_query, :sync_required_query

  def initialize( published_events_query: PublishedEventsQuery,
                  sync_required_query:    EventsRequiringSyncQuery )
    @event_publishing_adapter = CalSync.build_event_publishing_adapter
    @published_events_query   = published_events_query
    @sync_required_query      = sync_required_query
  end


  def apply
    @results ||= publish
    @successes, @failures, @publishing_record = *@results
  end


  def source_event_ids
    @source_event_ids ||= source_events.keys
  end


  def source_events
    @source_events ||= sync_required_query.new.call.hash_by(:id)
  end


  def published_events
    published_events_query.new(source_id: source_event_ids).call.hash_by(:source_id)
  end


  def previously_published?(source_event)
    published_events.key?(source_event.id)
  end


  def dto_for_update(source, published)
    CalendarAdapters::EventDTO.request(
      destination_id: published.destination_id,
      source_id:      source.id,
      calendar_id:    published.calendar_id,
      start_time:     source.start_time,
      end_time:       source.end_time,
      all_day:        false,
      name:           source.name,
      description:    source.description,
      group:          source.group_name,
      source_url:     source.url,
      location:       source.location_string,
      tags:           source.tags,
      last_update:    source.last_update
    )
  end


  def dto_for_create(source)
    CalendarAdapters::EventDTO.request(
      calendar_id:  CalSync.default_output_calendar.id,
      source_id:    source.id,
      start_time:   source.start_time,
      end_time:     source.end_time,
      all_day:      false,
      name:         source.name,
      description:  source.description,
      group:        source.group_name,
      source_url:   source.url,
      location:     source.location_string,
      tags:         source.tags,
      last_update:  source.last_update
    )
  end


private ########################################################################


  def publish
    published = source_events.map.rate_limit(*CalSync.meetup_query_rate, &method(:publish_single))
    failures  = published.select { |result| result.failure? or result == :failed }
    publishing_record = record_publishing_details(published).keys
    [published, failures, publishing_record]
  end


  def publish_single(src_evt)
    if previously_published?(src_evt)
      event_adapter.update(dto_for_update(src_evt, published_events[src_evt.id]))
    else
      event_adapter.create(dto_for_create(src_evt))
    end
  rescue
    :failed # TODO: Actual error logging.
  end


  def record_publishing_details(pub_evts)
    pub_evts.map do |published|
      record = PublishedEvent.find_or_initialize(
        source_id:      published.source_id,
        destination_id: published.destination_id
      )
      record.details = published.details
      [record.source_id, record.save]
    end.to_h
  end

end
