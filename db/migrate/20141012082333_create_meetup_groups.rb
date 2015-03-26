class CreateMeetupGroups < ActiveRecord::Migration
  def change
    create_table "meetup_groups", id: false, primary_key: 'meetup_group_id' do |t|
      t.string  "meetup_group_id",  null: false
      t.string  "name",             null: false
      t.string  "urlname",          null: false
      t.boolean "enable_sync",      null: false, default: true
      t.string  "tags",             null: false, default: [], array: true

      t.timestamps
    end
  end
end
