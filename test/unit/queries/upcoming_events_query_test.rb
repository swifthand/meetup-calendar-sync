require 'test_helper'

class UpcomingEventsQueryTest < ActiveSupport::TestCase

  def api_response_json
    json_path = "test/unit/queries/meetup_api_events_response.json"
    @api_response_json ||= File.read(File.join(Rails.root, json_path))
  end

  def api_response_hash
    @api_response_hash ||= BIGASSHASH.clone
  end

  def mock_client
    MockClient.new(api_response_json)
  end

  # The only method we need to mock out is get_path
  MockClient = Struct.new(:respond_with) do
    def get_path(*args); respond_with; end
  end


  test "parses api response json into events" do
    query = UpcomingEventsQuery.new
    built_events = query.events_from_result(api_response_json.clone)
    assert_equal(4, built_events.count)
    JSON.parse(api_response_json)['results'].map do |response|
      MeetupEvent.from_api_response(response)
    end.each do |direct_event|
      assert_includes(built_events, direct_event)
    end
  end


  test "can be called successfully" do
    query = UpcomingEventsQuery.new(client: mock_client)
    # Empty case
    events = query.(groups: [])
    assert_empty(events)
    events = query.(groups: nil)
    assert_empty(events)
    # Single group case.
    events = query.(groups: MeetupGroup.new)
    assert_equal(4, events.count)
    # Multiple group case.
    events = query.(groups: [MeetupGroup.new, MeetupGroup.new, MeetupGroup.new])
    assert_equal(12, events.count)
  end


  test "sleeps between chunks" do
    query = UpcomingEventsQuery.new(
      delay:      0.25,
      chunk_size: 2,
      client:     mock_client)
    four_groups = [MeetupGroup.new, MeetupGroup.new, MeetupGroup.new, MeetupGroup.new]
    t0 = Time.now
    query.(groups: four_groups)
    elapsed = Time.now - t0
    # elapsed should be between 0.25 and 0.50 unless the query call to a mock client
    # somehow took over 0.25s, which is likely a transient fluke of the test env.
    assert(0.25 < elapsed, "Time elapsed seems to indicate improper sleeping.")
    assert(elapsed < 0.50, "Time elapsed seems to indicate improper sleeping.")
  end


  test "does not sleep if groups fit in one chunk" do
    query = UpcomingEventsQuery.new(
      delay:      1,
      chunk_size: 5,
      client:     mock_client)
    four_groups = [MeetupGroup.new, MeetupGroup.new, MeetupGroup.new, MeetupGroup.new]
    t0 = Time.now
    query.(groups: four_groups)
    elapsed = Time.now - t0
    assert(elapsed < 1.0, "Time elapsed seems to indicate the query slept when it should not have.")
  end


################################################################################


  BIGASSHASH = {
    "results" => [
      { "utc_offset" => -21600000,
        "headcount" => 0,
        "visibility" => "public",
        "waitlist_count" => 0,
        "created" => 1391402959000,
        "maybe_rsvp_count" => 0,
        "description" => "<p>Hi ladies,</p> <p>Please join us in working together Saturday afternoon, February 1st. Bring your coding projects and questions. All skill levels welcome! Invite anyone you know who has coding projects or even online learning they would like to do.</p> <p>We are looking to provide a friendly and helpful environment to ladies who code or are learning to code.</p> <p>There will be snacks and drinks =).</p> <p>We will confirm a location as this session approaches, but we will probably meet at either Brightwork or Platform.</p>",
        "event_url" => "http://www.meetup.com/Girls-Coding-Club/events/qbtcthytpbcc/",
        "yes_rsvp_count" => 1,
        "duration" => 10800000,
        "name" => "Let's Code Together!",
        "id" => "qbtcthytpbcc",
        "time" => 1448136000000,
        "updated" => 1391402959000,
        "group" => {
          "join_mode" => "approval",
          "created" => 1382105295000,
          "name" => "Girls Coding Club",
          "group_lon" => -95.38999938964844,
          "id" => 10741142,
          "urlname" => "Girls-Coding-Club",
          "group_lat" => 29.739999771118164,
          "who" => "Coders"
        },
        "status" => "upcoming"
      },
      {
        "utc_offset" => -21600000,
        "headcount" => 0,
        "visibility" => "public",
        "waitlist_count" => 0,
        "created" => 1391402959000,
        "maybe_rsvp_count" => 0,
        "description" => "<p>Hi ladies,</p> <p>Please join us in working together Saturday afternoon, February 1st. Bring your coding projects and questions. All skill levels welcome! Invite anyone you know who has coding projects or even online learning they would like to do.</p> <p>We are looking to provide a friendly and helpful environment to ladies who code or are learning to code.</p> <p>There will be snacks and drinks =).</p> <p>We will confirm a location as this session approaches, but we will probably meet at either Brightwork or Platform.</p>",
        "event_url" => "http://www.meetup.com/Girls-Coding-Club/events/qbtcthytqbhb/",
        "yes_rsvp_count" => 1,
        "duration" => 10800000,
        "name" => "Let's Code Together!",
        "id" => "qbtcthytqbhb",
        "time" => 1449345600000,
        "updated" => 1391402959000,
        "group" => {
          "join_mode" => "approval",
          "created" => 1382105295000,
          "name" => "Girls Coding Club",
          "group_lon" => -95.38999938964844,
          "id" => 10741142,
          "urlname" => "Girls-Coding-Club",
          "group_lat" => 29.739999771118164,
          "who" => "Coders"
        },
        "status" => "upcoming"
      },
      {
        "utc_offset" => -21600000,
        "headcount" => 0,
        "visibility" => "public",
        "waitlist_count" => 0,
        "created" => 1391402959000,
        "maybe_rsvp_count" => 0,
        "description" => "<p>Hi ladies,</p> <p>Please join us in working together Saturday afternoon, February 1st. Bring your coding projects and questions. All skill levels welcome! Invite anyone you know who has coding projects or even online learning they would like to do.</p> <p>We are looking to provide a friendly and helpful environment to ladies who code or are learning to code.</p> <p>There will be snacks and drinks =).</p> <p>We will confirm a location as this session approaches, but we will probably meet at either Brightwork or Platform.</p>",
        "event_url" => "http://www.meetup.com/Girls-Coding-Club/events/qbtcthytqbzb/",
        "yes_rsvp_count" => 1,
        "duration" => 10800000,
        "name" => "Let's Code Together!",
        "id" => "qbtcthytqbzb",
        "time" => 1450555200000,
        "updated" => 1391402959000,
        "group" => {
          "join_mode" => "approval",
          "created" => 1382105295000,
          "name" => "Girls Coding Club",
          "group_lon" => -95.38999938964844,
          "id" => 10741142,
          "urlname" => "Girls-Coding-Club",
          "group_lat" => 29.739999771118164,
          "who" => "Coders"
        },
        "status" => "upcoming"
      },
      {
        "utc_offset" => -21600000,
        "headcount" => 0,
        "visibility" => "public",
        "waitlist_count" => 0,
        "created" => 1391402959000,
        "maybe_rsvp_count" => 0,
        "description" => "<p>Hi ladies,</p> <p>Please join us in working together Saturday afternoon, February 1st. Bring your coding projects and questions. All skill levels welcome! Invite anyone you know who has coding projects or even online learning they would like to do.</p> <p>We are looking to provide a friendly and helpful environment to ladies who code or are learning to code.</p> <p>There will be snacks and drinks =).</p> <p>We will confirm a location as this session approaches, but we will probably meet at either Brightwork or Platform.</p>",
        "event_url" => "http://www.meetup.com/Girls-Coding-Club/events/qbtcthyvcbdb/",
        "yes_rsvp_count" => 1,
        "duration" => 10800000,
        "name" => "Let's Code Together!",
        "id" => "qbtcthyvcbdb",
        "time" => 1451764800000,
        "updated" => 1391402959000,
        "group" => {
          "join_mode" => "approval",
          "created" => 1382105295000,
          "name" => "Girls Coding Club",
          "group_lon" => -95.38999938964844,
          "id" => 10741142,
          "urlname" => "Girls-Coding-Club",
          "group_lat" => 29.739999771118164,
          "who" => "Coders"
        },
        "status" => "upcoming"
      }
    ],
    "meta" => {
      "next" => "https://api.meetup.com/2/events?offset=1&sign=True&format=json&limited_events=False&group_urlname=Girls-Coding-Club&photo-host=public&page=20&fields=&order=time&status=upcoming&desc=false",
      "method" => "Events",
      "total_count" => 25,
      "link" => "https://api.meetup.com/2/events",
      "count" => 20,
      "description" => "Access Meetup events using a group, member, or event id. Events in private groups are available only to authenticated members of those groups. To search events by topic or location, see [Open Events](/meetup_api/docs/2/open_events).",
      "lon" => "",
      "title" => "Meetup Events v2",
      "url" => "https://api.meetup.com/2/events?offset=0&sign=True&format=json&limited_events=False&group_urlname=Girls-Coding-Club&photo-host=public&page=20&fields=&order=time&status=upcoming&desc=false",
      "signed_url" => "https://api.meetup.com/2/events?offset=0&format=json&limited_events=False&group_urlname=Girls-Coding-Club&photo-host=public&page=20&fields=&order=time&status=upcoming&desc=false&sig_id=49720892&sig=463d277066525510c93f8ddc81456f5d492ebefd",
      "id" => "",
      "updated" => 1426964900000,
      "lat" => ""
    }
  }


end
