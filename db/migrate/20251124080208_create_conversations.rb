class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.string :user_id, null: false, index: { unique: true }
      t.string :topic
      t.string :stage, default: "start"
      t.integer :question_no, default: 0
      t.json :questions_json
      t.json :answers_json
      t.string :level
      t.text :analysis_text
      t.timestamps
    end
  end
end
