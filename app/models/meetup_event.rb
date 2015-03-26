class MeetupEvent < ActiveRecord::Base
  self.primary_key = "meetup_event_id"

  belongs_to  :meetup_group, foreign_key: "meetup_group_id"

  class << self
    def enabled
      where(enable_sync: true)
    end

    def from_api_response(response)
      self.new(
        meetup_event_id: response['id'],
        meetup_group_id: response['group']['id'],
        meetup_last_update: response['updated'],
        name:       response['name'],
        start_time: LocalTime.convert(response['time']),
        end_time:   LocalTime.convert(response['time'] + response['duration']),
        details:    response
      )
    end
  end


  def update_from(another_event)
    self.update_attributes(
      meetup_last_update: another_event.meetup_last_update,
      name:               another_event.name,
      start_time:         another_event.start_time,
      end_time:           another_event.end_time,
      details:            another_event.details
    )
  end


end
