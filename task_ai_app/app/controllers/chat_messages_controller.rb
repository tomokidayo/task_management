class ChatMessagesController < ApplicationController
  def create
    @chat_session = ChatSession.find(params[:chat_session_id])

    # ユーザーのメッセージ
    @chat_message = @chat_session.chat_messages.create!(
      role: "user",
      content: params[:content]
    )

    # AI の返答
    ai_reply = GeminiClient.chat(@chat_session.chat_messages)

    # ★ これが必要！
    @assistant_message = @chat_session.chat_messages.create!(
      role: "assistant",
      content: ai_reply
    )

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @chat_session }
    end
  end
end
