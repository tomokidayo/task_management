class ChatMessage < ApplicationRecord
  belongs_to :chat_session
  enum role: {
    user: "user",
    assistant: "assistant",
    system: "system"
  }
end
