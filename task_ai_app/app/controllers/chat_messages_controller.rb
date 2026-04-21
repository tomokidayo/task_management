class ChatMessagesController < ApplicationController
  def create
    @chat_session = ChatSession.find(params[:chat_session_id])

    # ユーザーのメッセージ
    @chat_message = @chat_session.chat_messages.create!(
      role: "user",
      content: params[:content]
    )

    # ★ タスク一覧プロンプトを毎回先頭に追加
    system_prompt_message = @chat_session.chat_messages.find_by(role: :system)

    # messages_for_ai = [ system_prompt_message ] + @chat_session.chat_messages.where.not(role: :system)

    messages_for_ai = [ system_prompt_message ] +
      @chat_session.chat_messages.where.not(role: :system).where.not(content: nil)


    # AI の返答
    ai_reply = GeminiClient.chat(messages_for_ai)

    if ai_reply.nil? || ai_reply == ""
      Rails.logger.error("Gemini API Error: AI reply is nil or empty")
      return
    end

    # AIの返答を保存
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
