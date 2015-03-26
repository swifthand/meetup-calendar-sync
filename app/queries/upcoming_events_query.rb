class UpcomingEventsQuery

  attr_reader :delay, :requests_per_round, :client

  def initialize(delay: 0.5, requests_per_round: 5, client: CalSync.meetup_client.new)
    @delay = 0.5
    @requests_per_round = requests_per_round
    @client = client
  end


  def call(groups: EnabledGroupsQuery.call)
    [*groups]
      .each_slice(requests_per_round)
      .map(&method(:fetch_events))
      .flatten
  end


  def events_from_result(result)
    result_hash = JSON.parse(result)
    result_hash['results'].map do |result|
      MeetupEvent.from_api_response(result)
    end
  end


private ########################################################################


  def fetch_events(groups)
    result = [*groups].map do |group|
      events_from_result(
        client.get_path("/2/events", {
          group_urlname:  group.urlname,
          status:         "upcoming"
        }))
    end
    sleep(delay)
    result
  end

end
