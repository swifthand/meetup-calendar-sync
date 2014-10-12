class MeetupGroup < ActiveRecord::Base
  self.primary_key = "meetup_group_id"

  has_many  :meetup_events, foreign_key: "meetup_group_id"

end