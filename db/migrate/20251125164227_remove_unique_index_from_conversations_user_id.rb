class RemoveUniqueIndexFromConversationsUserId < ActiveRecord::Migration[8.0]
  def change
    remove_index :conversations, :user_id

    # Then add a normal, non-unique index
    add_index :conversations, :user_id
  end
end
