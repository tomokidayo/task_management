class ChatSessionsController < ApplicationController
  def index
    @chat_sessions = ChatSession.all
  end

  def show
    @chat_session = ChatSession.find(params[:id])
    @chat_messages = @chat_session.chat_messages
  end

  def create
    @chat_session = ChatSession.create!(user: current_user)
    redirect_to @chat_session
  end
end
