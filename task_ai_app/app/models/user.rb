class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :chat_sessions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  validates :name, presence: { message: "ユーザー名を入力してください" }
  validates :email, presence: { message: "メールアドレスを入力してください" }
  # validates :password, length: { minimum: 6, message: "パスワードは6文字以上で入力してください" }, if: :password_required?
  validates :password,
  length: { minimum: 6, message: "パスワードは6文字以上で入力してください" },
  confirmation: { message: "パスワードが一致しません" },
  if: :password_required?

  validates :password_confirmation,
  presence: { message: "確認用パスワードを入力してください" },
  if: :password_required?

  validates :email, uniqueness: { case_sensitive: false, message: "このメールアドレスは既に使用されています" }

  private

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end
end
