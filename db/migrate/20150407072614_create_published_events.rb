class CreatePublishedEvents < ActiveRecord::Migration
  def change
    create_table 'published_events', id: false, primary_key: 'source_id' do |t|
      t.string  'source_id',      null: false
      t.string  'destination_id', null: false
      t.string  'type',           null: false, default: 'GoogleGateway::PublishedEvent'
      t.json    'details',        null: false, default: {}

      t.timestamps
    end
  end
end
