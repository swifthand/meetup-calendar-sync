class CreateSettings < ActiveRecord::Migration
  def change
    create_table "settings", id: false, primary_key: 'key' do |t|
      t.string  'key',    null: false
      t.json    'value',  null: false

      t.timestamps
    end
  end
end

