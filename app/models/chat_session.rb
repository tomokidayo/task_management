# チャットセッションを表すモデル
#
# 1人のユーザーが複数のチャットセッションを持つことができ、
# 各セッションには複数のメッセージ（ChatMessage）が紐づく。
# Gemini などの AI との対話履歴を管理する中心的なモデル。
#
# @!attribute [rw] title
#   @return [String] セッションのタイトル（任意）
#
# @!attribute [rw] user_id
#   @return [Integer] セッションを所有するユーザーの ID
#
# @!method user
#   @return [User] このチャットセッションを所有するユーザー
#
# @!method chat_messages
#   @return [Array<ChatMessage>] セッションに紐づくメッセージ一覧
class ChatSession < ApplicationRecord
  # --- Associations ---------------------------------------------------------

  # セッションを所有するユーザー
  #
  # @return [User]
  belongs_to :user

  # セッションに紐づくメッセージ
  #
  # @return [Array<ChatMessage>]
  has_many :chat_messages, dependent: :destroy
end
