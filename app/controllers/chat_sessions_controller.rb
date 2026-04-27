<<<<<<< HEAD
class ChatSessionsController < ApplicationController
=======
# チャットセッションを管理するコントローラ
#
# ユーザーごとのチャットセッション一覧表示、詳細表示、セッション作成を担当する。
# セッション作成時には、ユーザーのタスク状況をもとにした system プロンプトを生成し、
# AI（Gemini）との対話の初期コンテキストとして保存する。
#
# @see ChatSession
# @see ChatMessage
class ChatSessionsController < ApplicationController
  # チャットセッション一覧を表示する
  #
  # @return [void]
>>>>>>> develop
  def index
    @chat_sessions = current_user.chat_sessions
  end

<<<<<<< HEAD
  def show
    # @chat_session = ChatSession.find(params[:id])
    @chat_session = current_user.chat_sessions.find(params[:id])

    # @chat_messages = @chat_session.chat_messages
    @chat_messages = @chat_session.chat_messages.where.not(role: "system")
  end

  # def create
  #   @chat_session = ChatSession.create!(user: current_user)
  #   redirect_to @chat_session
  # end

  def create
    @chat_session = current_user.chat_sessions.create!

    tasks = current_user.tasks.order(:deadline)

=======
  # チャットセッションの詳細を表示する
  #
  # @return [void]
  # @note system メッセージは履歴から除外して表示する
  def show
    @chat_session = current_user.chat_sessions.find(params[:id])
    @chat_messages = @chat_session.chat_messages.where.not(role: "system")
  end

  # 新しいチャットセッションを作成する
  #
  # @return [void]
  # @note 作成時にユーザーのタスク一覧をもとに system プロンプトを生成する
  def create
    @chat_session = current_user.chat_sessions.create!

    # --- タスク情報の取得 ---------------------------------------------------
    tasks = current_user.tasks.order(:deadline)

    # タスクの要約（AI に渡すコンテキスト）
>>>>>>> develop
    task_summary = tasks.map do |t|
      "- #{t.title}（優先度: #{t.priority_label} / ステータス: #{t.status_label} / 締切: #{t.deadline&.strftime("%Y-%m-%d")}）"
    end.join("\n")

<<<<<<< HEAD
=======
    # --- system プロンプト生成 ---------------------------------------------
>>>>>>> develop
    system_prompt = <<~TEXT
      あなたはタスク管理をサポートするアシスタントです。
      ユーザーが現在抱えているタスクは以下の通りです。

      #{task_summary}

      これらのタスク状況を踏まえて、ユーザーの相談に答えてください。
      アドバイスは簡潔で、実行可能で、優先順位付けを意識してください。
      必要に応じて質問し、状況を深掘りしてください。
    TEXT

<<<<<<< HEAD
=======
    # system メッセージを最初に保存
>>>>>>> develop
    @chat_session.chat_messages.create!(
      role: "system",
      content: system_prompt
    )

    redirect_to @chat_session
  end
end
