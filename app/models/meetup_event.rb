class MeetupEvent < ActiveRecord::Base
  self.primary_key = "meetup_event_id"

  belongs_to  :meetup_group, foreign_key: "meetup_group_id"

end