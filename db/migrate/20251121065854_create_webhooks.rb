class CreateWebhooks < ActiveRecord::Migration[8.0]
  def change
    create_table :webhooks do |t|
      t.string :event_id
      t.string :event_type
      t.text :payload
      t.boolean :processed

      t.timestamps
    end
  end
end
