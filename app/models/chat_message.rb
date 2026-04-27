# チャットメッセージを表すモデル
#
# ChatSession に紐づく個々のメッセージを管理する。
# ユーザーの発言、AI の返答、システムプロンプトなど
# 役割（role）によってメッセージの種類を区別する。
#
# @!attribute [rw] content
#   @return [String] メッセージ本文
#
# @!attribute [rw] role
#   @return [String] メッセージの役割（user / assistant / system）
#
# @!attribute [rw] chat_session_id
#   @return [Integer] 紐づくチャットセッションの ID
#
# @!method chat_session
#   @return [ChatSession] このメッセージが属するチャットセッション
class ChatMessage < ApplicationRecord
  # --- Associations ---------------------------------------------------------

  # メッセージが属するチャットセッション
  #
  # @return [ChatSession]
  belongs_to :chat_session

  # --- Enums ---------------------------------------------------------------

  # メッセージの役割を表す enum
  #
  # @!scope class
  # @!method user
  #   @return [ChatMessage] ユーザーの発言
  #
  # @!method assistant
  #   @return [ChatMessage] AI の返答
  #
  # @!method system
  #   @return [ChatMessage] システムプロンプト
  enum role: {
    user: "user",
    assistant: "assistant",
    system: "system"
  }
end
