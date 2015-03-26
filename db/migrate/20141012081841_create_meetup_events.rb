class CreateMeetupEvents < ActiveRecord::Migration
  def change
    create_table "meetup_events", id: false, primary_key: 'meetup_event_id' do |t|
      t.string    "meetup_event_id",    null: false
      t.string    "meetup_group_id",    null: false
      # As a Postgres bigint, not a simple integer:
      t.integer   "meetup_last_update", null: false,                limit: 8

      t.boolean   "requires_sync",      null: false, default: true

      t.string    "name",               null: false
      t.datetime  "start_time",         null: false
      t.datetime  "end_time",           null: false

      t.json      "details",            null: false, default: {}

      t.timestamps
    end
  end
end
