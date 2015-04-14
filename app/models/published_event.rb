class PublishedEvent < ActiveRecord::Base
  self.primary_key = "source_id"
  belongs_to  :meetup_group, foreign_key: "meetup_group_id"
  serialize :details, HashSerializer
end
