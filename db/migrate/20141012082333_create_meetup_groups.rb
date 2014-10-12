class CreateMeetupGroups < ActiveRecord::Migration
  def change
    create_table :meetup_groups, id: false, primary_key: 'meetup_group_id' do |t|
      t.string "meetup_group_id", null: false
      t.string "name",            null: false

      t.timestamps
    end
  end
end
