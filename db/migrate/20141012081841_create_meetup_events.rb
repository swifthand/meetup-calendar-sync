class CreateMeetupEvents < ActiveRecord::Migration
  def change
    create_table "meetup_events", id: false, primary_key: 'meetup_event_id' do |t|
      t.string  "meetup_event_id",    null: false
      t.string  "meetup_group_id",    null: false
      t.integer "meetup_last_update", null: false
      t.json    "details",            null: false, default: {}

      t.timestamps
    end
  end
end
