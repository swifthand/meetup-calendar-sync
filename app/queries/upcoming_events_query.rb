class UpcomingEventsQuery

  attr_reader :delay, :chunk_size, :client

  def initialize( delay:      CalSync.request_delay,
                  chunk_size: CalSync.requests_per_delay,
                  client:     CalSync.meetup_client.new )
    @delay      = delay
    @chunk_size = chunk_size
    @client     = client
  end


  def call(groups: EnabledGroupsQuery.call)
    groups = [*groups]
    groups
      .each_slice(chunk_size)
      .map.with_index do |slice, idx|
        is_last_slice = ((idx + 1) * chunk_size >= groups.count)
        fetch_events(slice, is_last_slice)
      end
      .flatten
  end


  def events_from_result(result)
    result_hash = JSON.parse(result)
    result_hash['results'].map do |result|
      MeetupEvent.from_api_response(result)
    end
  end


private ########################################################################


  def fetch_events(groups, skip_sleep = false)
    result = [*groups].map do |group|
      events_from_result(
        client.get_path("/2/events", {
          group_urlname:  group.urlname,
          status:         "upcoming"
        }))
    end
    sleep(delay) unless skip_sleep
    result
  end

end
