class AddUserIdToChatMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :chat_messages, :user_id, :integer
    add_index :chat_messages, :user_id
  end
end
