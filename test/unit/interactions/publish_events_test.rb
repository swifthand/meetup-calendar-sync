require 'test_helper'

# Collaborator objects that these tests expect to stub/mock:
#   A query for fetching meetup events needing sync.
#   A query for which events have already been published.
#   CalSync.build_event_publishing_adapter
#   CalSync.meetup_query_rate
#   CalSync.default_output_calendar
class PublishEventsTest < ActiveSupport::TestCase
  fixtures :meetup_events, :meetup_groups, :published_events

  def meetup_event_source
    @meetup_event_source ||= stub_query(->() {
      [ meetup_events(:clojure_needs_sync_new),
        meetup_events(:clojure_needs_sync_update)
      ]
    })
  end


  def published_events_query
    @published_events_query ||= stub_query(->() {
      [ published_events(:clojure_needs_sync_update) ]
    })
  end


  def build_query
    PublishEvents.new(
      sync_required_query:    meetup_event_source,
      published_events_query: published_events_query
    )
  end


  class MockEventPublishingAdapter
    def create(event_dto)

    end

    def update(event_dto)

    end
  end


  def env(&block)
    CalSync.override_env(
      build_event_publishing_adapter: MockEventPublishingAdapter,
      meetup_query_rate: [1000, per: 0],
      default_output_calendar: OutputCalendar.new(
        name:     'Houston Nexus Test Calendar',
        id:       ENV['TEST_GOOGLE_CALENDAR_ID'],
        tags:     'primary',
        service:  'google',
        access_params: { id: ENV['TEST_GOOGLE_CALENDAR_ID'] }
      ),
      &block)
  end


  test "produces update and create dto requests" do
    env do
      query = build_query
      assert_equal(
        request_dtos(:clojure_needs_sync_new),
        query.dto_for_create(meetup_events(:clojure_needs_sync_new)))
      assert_equal(
        request_dtos(:clojure_needs_sync_update),
        query.dto_for_update(meetup_events(:clojure_needs_sync_update), published_events(:clojure_needs_sync_update)))
    end
  end


  test "" do

  end


  def request_dtos(key); REQUEST_DTOS[key]; end
  REQUEST_DTOS = {
    clojure_needs_sync_new: CalendarAdapters::EventDTO.request(
      source_id:    "dsrlxdytkbfc",
      calendar_id:  ENV['TEST_GOOGLE_CALENDAR_ID'],
      start_time:   DateTime.parse('2015-07-24 05:00:00.000000000 Z'),
      end_time:     DateTime.parse('2015-07-24 07:00:00.000000000 Z'),
      all_day:      false,
      name:         'Monthly meetup - TBD',
      description:  "<p>The monthly meeting. Topic TBD</p>",
      group:        "Clojure Houston User Group",
      source_url:   "http://www.meetup.com/Clojure-Houston-User-Group/events/dsrlxdytkbfc/",
      location:     "START houston, 1121 Delano Street, Houston, TX 77003",
      tags:         [],
      last_update:  DateTime.parse("Mon, 10 Mar 2014 20:09:29 CDT -05:00")
    ),
    clojure_needs_sync_update: CalendarAdapters::EventDTO.request(
      source_id:      'dsrlxdytlbkc',
      destination_id: '24l2gvkdorgkou9ccvqrmurmno',
      calendar_id:    ENV['TEST_GOOGLE_CALENDAR_ID'],
      start_time:     DateTime.parse('2015-08-28 05:00:00.000000000 Z'),
      end_time:       DateTime.parse('2015-08-28 07:00:00.000000000 Z'),
      all_day:        false,
      name:           "Monthly meetup - TBD",
      description:    "<p>The monthly meeting. Topic TBD</p>",
      group:          "Clojure Houston User Group",
      source_url:     "http://www.meetup.com/Clojure-Houston-User-Group/events/dsrlxdytlbkc/",
      location:       "START houston, 1121 Delano Street, Houston, TX 77003",
      tags:           [],
      last_update:    LocalTime.convert(1394500169000)
    )
  }


  def response_dtos(key); RESPONSE_DTOS[key]; end
  RESPONSE_DTOS = {
    clojure_needs_sync_new: CalendarAdapters::EventDTO.response(
      source_id:    "dsrlxdytkbfc",
      calendar_id:  ENV['TEST_GOOGLE_CALENDAR_ID'],
      start_time:   DateTime.parse('2015-07-24 05:00:00.000000000 Z'),
      end_time:     DateTime.parse('2015-07-24 07:00:00.000000000 Z'),
      all_day:      false,
      name:         'Monthly meetup - TBD',
      description:  "<p>The monthly meeting. Topic TBD</p>",
      group:        "Clojure Houston User Group",
      source_url:   "http://www.meetup.com/Clojure-Houston-User-Group/events/dsrlxdytkbfc/",
      location:     "START houston, 1121 Delano Street, Houston, TX 77003",
      tags:         [],
      last_update:  DateTime.parse("Mon, 10 Mar 2014 20:09:29 CDT -05:00")
    ),
    clojure_needs_sync_update: CalendarAdapters::EventDTO.response(
      source_id:      'dsrlxdytlbkc',
      destination_id: '24l2gvkdorgkou9ccvqrmurmno',
      calendar_id:    ENV['TEST_GOOGLE_CALENDAR_ID'],
      start_time:     DateTime.parse('2015-08-28 05:00:00.000000000 Z'),
      end_time:       DateTime.parse('2015-08-28 07:00:00.000000000 Z'),
      all_day:        false,
      name:           "Monthly meetup - TBD",
      description:    "<p>The monthly meeting. Topic TBD</p>",
      group:          "Clojure Houston User Group",
      source_url:     "http://www.meetup.com/Clojure-Houston-User-Group/events/dsrlxdytlbkc/",
      location:       "START houston, 1121 Delano Street, Houston, TX 77003",
      tags:           [],
      last_update:    LocalTime.convert(1394500169000)
    )
  }



end
