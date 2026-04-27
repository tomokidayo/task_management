<<<<<<< HEAD
class ChatMessagesController < ApplicationController
  def create
    # @chat_session = ChatSession.find(params[:chat_session_id])
    @chat_session = current_user.chat_sessions.find(params[:chat_session_id])


    # ユーザーのメッセージ
=======
# チャットメッセージを管理するコントローラ
#
# ユーザーの入力メッセージを保存し、AI（Gemini）へ送信するための
# メッセージ配列を構築し、AI の返答を保存する役割を持つ。
#
# @see ChatSession
# @see ChatMessage
class ChatMessagesController < ApplicationController
  # メッセージを作成し、AI に送信して返答を保存する
  #
  # @return [void]
  # @note Turbo Stream に対応しているため、非同期で画面更新される
  def create
    # セッションの取得（ユーザーの所有権を保証）
    @chat_session = current_user.chat_sessions.find(params[:chat_session_id])

    # --- ユーザーのメッセージを保存 ----------------------------------------
>>>>>>> develop
    @chat_message = @chat_session.chat_messages.create!(
      role: "user",
      content: params[:content],
      user_id: current_user.id
    )

<<<<<<< HEAD
    # ★ タスク一覧プロンプトを毎回先頭に追加
    system_prompt_message = @chat_session.chat_messages.find_by(role: :system)

    # messages_for_ai = [ system_prompt_message ] + @chat_session.chat_messages.where.not(role: :system)

    messages_for_ai = [ system_prompt_message ] +
      @chat_session.chat_messages.where.not(role: :system).where.not(content: nil)


    # AI の返答
=======
    # --- system プロンプトの取得 -------------------------------------------
    # 毎回 AI に渡すメッセージの先頭に置く
    system_prompt_message = @chat_session.chat_messages.find_by(role: :system)

    # --- AI に渡すメッセージ配列を構築 -------------------------------------
    # system → user/assistant の順で全履歴を渡す
    messages_for_ai = [ system_prompt_message ] +
      @chat_session.chat_messages.where.not(role: :system).where.not(content: nil)

    # --- AI の返答を取得 ----------------------------------------------------
>>>>>>> develop
    ai_reply = GeminiClient.chat(messages_for_ai)

    if ai_reply.nil? || ai_reply == ""
      Rails.logger.error("Gemini API Error: AI reply is nil or empty")
      return
    end

<<<<<<< HEAD
    # AIの返答を保存
=======
    # --- AI の返答を保存 ----------------------------------------------------
>>>>>>> develop
    @assistant_message = @chat_session.chat_messages.create!(
      role: "assistant",
      content: ai_reply,
      user_id: current_user.id
    )

<<<<<<< HEAD
=======
    # --- レスポンス ---------------------------------------------------------
>>>>>>> develop
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @chat_session }
    end
  end
end
