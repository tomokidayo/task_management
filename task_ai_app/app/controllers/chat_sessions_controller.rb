class ChatSessionsController < ApplicationController
  def index
    @chat_sessions = current_user.chat_sessions
  end

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

    task_summary = tasks.map do |t|
      "- #{t.title}（優先度: #{t.priority_label} / ステータス: #{t.status_label} / 締切: #{t.deadline&.strftime("%Y-%m-%d")}）"
    end.join("\n")

    system_prompt = <<~TEXT
      あなたはタスク管理をサポートするアシスタントです。
      ユーザーが現在抱えているタスクは以下の通りです。

      #{task_summary}

      これらのタスク状況を踏まえて、ユーザーの相談に答えてください。
      アドバイスは簡潔で、実行可能で、優先順位付けを意識してください。
      必要に応じて質問し、状況を深掘りしてください。
    TEXT

    @chat_session.chat_messages.create!(
      role: "system",
      content: system_prompt
    )

    redirect_to @chat_session
  end
end
