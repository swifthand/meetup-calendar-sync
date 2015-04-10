class PublishedEvent < ActiveRecord::Base
  belongs_to  :meetup_group, foreign_key: "meetup_group_id"
  serialize :details, HashSerializer
end
