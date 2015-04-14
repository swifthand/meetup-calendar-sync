class UpcomingEventsQuery

  attr_reader :client

  def initialize(client: CalSync.meetup_client.new )
    @client = client
  end


  def call(groups: EnabledGroupsQuery.call)
    groups = [*groups]
    groups.map.rate_limit(*CalSync.meetup_query_rate) do |group|
      fetch_events(group)
    end.flatten
  end


  def events_from_result(api_results)
    result_hash = JSON.parse(api_results)
    result_hash['results'].map do |result|
      if required_attrs?(result)
        MeetupEvent.from_api_response(result)
      else
        nil
      end
    end.compact
  end


  def required_attrs?(result_hash)
    result_hash.key?('time')
  end

private ########################################################################


  def fetch_events(group)
    events_from_result(
      client.get_path("/2/events", {
        group_urlname:  group.urlname,
        status:         "upcoming"
      }))
  end

end
