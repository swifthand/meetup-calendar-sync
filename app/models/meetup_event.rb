class MeetupEvent < ActiveRecord::Base
  self.primary_key = "meetup_event_id"

  belongs_to  :meetup_group,      foreign_key: "meetup_group_id"
  has_many    :published_events,  foreign_key: "source_id"

  class << self
    def requires_sync
      where(requires_sync: true)
    end

    def from_api_response(response)
      start_time  = LocalTime.convert(response['time'].to_i)
      end_time    = if response['duration'].blank?
                      start_time + 2.hours
                    else
                      LocalTime.convert(response['time'].to_i + response['duration'].to_i)
                    end
      result = self.new(
        meetup_event_id:    response['id'],
        meetup_group_id:    response['group']['id'],
        meetup_last_update: response['updated'].to_i,
        name:           response['name'],
        start_time:     start_time,
        end_time:       end_time,
        details:        response,
        requires_sync:  true
      )
      result
    end

  end

  def tags
    meetup_group.tags
  end

  def update_from(another_event)
    self.update_attributes(
      meetup_last_update: another_event.meetup_last_update,
      name:               another_event.name,
      start_time:         another_event.start_time,
      end_time:           another_event.end_time,
      details:            another_event.details,
      requires_sync:      true
    )
  end

  def published!
    update_attributes(requires_sync: false)
  end


  def group_name
    details.fetch('group', {}).fetch('name', '')
  end


  def url
    details.fetch('event_url', '')
  end


  def last_update
    LocalTime.convert(meetup_last_update)
  end


  def location_string
    location = details.fetch('venue', {})
    str  = "#{location['address_1']} #{location['address_2']}"
    str << ", #{location['city']}" if location['city'].present?
    str << ", #{location['state']}" if location['state'].present?
    str << " #{location['zip']}"
    str  = "#{location['name']}, #{str}" if location['name'].present?
    str.gsub(/\s+/, ' ').gsub(/\s\,/, ',')
  end


  def method_missing(msg, *args, &block)
    if self[:details].key?(msg.to_s)
      result = self[:details][msg.to_s]
    else
      super
    end
  end

end
