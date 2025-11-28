class RemoveUniqueIndexFromConvsUserId < ActiveRecord::Migration[8.0]
  def change
    remove_index :conversations, :user_id

    # Add a NON-UNIQUE index instead
    add_index :conversations, :user_id
  end
end
