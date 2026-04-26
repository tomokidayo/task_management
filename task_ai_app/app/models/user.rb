# ユーザーを表すモデル
#
# Devise を利用して認証を行うユーザーアカウント。
# タスク管理・チャットセッション管理など、アプリの中心となるデータを保持する。
#
# @!attribute [rw] name
#   @return [String] ユーザー名
#
# @!attribute [rw] email
#   @return [String] メールアドレス（ユニーク）
#
# @!attribute [rw] password
#   @return [String] パスワード（6文字以上）
#
# @!attribute [rw] password_confirmation
#   @return [String] パスワード確認用
#
# @!method tasks
#   @return [Array<Task>] ユーザーが所有するタスク一覧
#
# @!method chat_sessions
#   @return [Array<ChatSession>] ユーザーが所有するチャットセッション一覧
class User < ApplicationRecord
  # --- Associations ---------------------------------------------------------

  # @!scope class
  # @!method has_many :tasks
  #   ユーザーに紐づくタスク
  has_many :tasks, dependent: :destroy

  # @!scope class
  # @!method has_many :chat_sessions
  #   ユーザーに紐づくチャットセッション
  has_many :chat_sessions, dependent: :destroy

  # --- Devise Modules -------------------------------------------------------

  # Devise による認証機能
  # @note :validatable を外しているため、パスワードやメールのバリデーションは手動で定義している
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # --- Validations ----------------------------------------------------------

  # @!group バリデーション

  # @return [void]
  # @note ユーザー名は必須
  validates :name, presence: { message: "ユーザー名を入力してください" }

  # @return [void]
  # @note メールアドレスは必須
  validates :email, presence: { message: "メールアドレスを入力してください" }

  # @return [void]
  # @note パスワードは6文字以上・確認用と一致している必要がある
  validates :password,
            length: { minimum: 6, message: "パスワードは6文字以上で入力してください" },
            confirmation: { message: "パスワードが一致しません" },
            if: :password_required?

  # @return [void]
  # @note 確認用パスワードも必須
  validates :password_confirmation,
            presence: { message: "確認用パスワードを入力してください" },
            if: :password_required?

  # @return [void]
  # @note メールアドレスはユニーク
  validates :email, uniqueness: { case_sensitive: false, message: "このメールアドレスは既に使用されています" }

  # @!endgroup

  private

  # パスワードのバリデーションが必要かどうかを判定する
  #
  # @return [Boolean] 新規作成時、またはパスワード関連の値が入力されている場合は true
  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end
end
