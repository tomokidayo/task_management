# タスクを表すモデル
#
# ユーザーに紐づくタスク情報を管理する。
# ステータス・優先度・締切・想定時間/実績時間など、
# タスク管理アプリの中心となるデータ構造。
#
# @!attribute [rw] title
#   @return [String] タスクのタイトル
#
# @!attribute [rw] description
#   @return [String] タスクの詳細説明
#
# @!attribute [rw] status
#   @return [String] ステータス（enum: not_started / in_progress / completed）
#
# @!attribute [rw] priority
#   @return [String] 優先度（enum: low / medium / high）
#
# @!attribute [rw] estimated_time
#   @return [Integer] 想定時間（分）
#
# @!attribute [rw] actual_time
#   @return [Integer] 実績時間（分）
#
# @!attribute [rw] deadline
#   @return [DateTime] 締切日時
#
# @!method user
#   @return [User] このタスクを所有するユーザー
class Task < ApplicationRecord
  # --- Associations ---------------------------------------------------------

  # @return [User] タスクの所有者
  belongs_to :user

  # --- Callbacks ------------------------------------------------------------

  # バリデーション前に HH:MM を分に変換する
  #
  # @return [void]
  before_validation :convert_times_to_minutes

  # --- Validations ----------------------------------------------------------

  # @return [void]
  # @note タイトルは必須
  validates :title, presence: { message: "タイトルを入力してください" }

  # --- Enums ---------------------------------------------------------------

  # @!group ステータス
  enum status: {
    not_started: 0,
    in_progress: 1,
    completed: 2
  }
  # @!endgroup

  # @!group 優先度
  enum priority: {
    low: 0,
    medium: 1,
    high: 2
  }
  # @!endgroup

  # --- Labels --------------------------------------------------------------

  # 優先度の日本語ラベル
  #
  # @return [String]
  PRIORITY_LABELS = {
    "low" => "通常",
    "medium" => "優先",
    "high" => "緊急"
  }.freeze

  # ステータスの日本語ラベル
  #
  # @return [String]
  STATUS_LABELS = {
    "not_started" => "未着手",
    "in_progress" => "進行中",
    "completed" => "完了"
  }.freeze

  # 優先度の日本語ラベルを返す
  #
  # @return [String]
  def priority_label
    PRIORITY_LABELS[priority]
  end

  # ステータスの日本語ラベルを返す
  #
  # @return [String]
  def status_label
    STATUS_LABELS[status]
  end

  # --- Time Conversion -----------------------------------------------------

  # estimated_time / actual_time を HH:MM → 分 に変換する
  #
  # @return [void]
  def convert_times_to_minutes
    self.estimated_time = hhmm_to_minutes(estimated_time)
    self.actual_time = hhmm_to_minutes(actual_time)
  end

  # HH:MM を分に変換する
  #
  # @param value [String, Integer, nil] HH:MM または分
  # @return [Integer, nil] 分に変換した値
  def hhmm_to_minutes(value)
    return value if value.is_a?(Integer)
    return nil if value.blank?
    h, m = value.split(":").map(&:to_i)
    h * 60 + m
  end

  # 分を HH:MM に変換する
  #
  # @param minutes [Integer, nil]
  # @return [String, nil] HH:MM 形式
  def minutes_to_hhmm(minutes)
    return nil if minutes.nil?
    format("%02d:%02d", minutes / 60, minutes % 60)
  end

  # 想定時間を HH:MM 形式で返す
  #
  # @return [String, nil]
  def estimated_time_hhmm
    minutes_to_hhmm(estimated_time)
  end

  # 実績時間を HH:MM 形式で返す
  #
  # @return [String, nil]
  def actual_time_hhmm
    minutes_to_hhmm(actual_time)
  end

  # --- Scopes --------------------------------------------------------------

  # キーワード検索
  #
  # @param keyword [String]
  # @return [ActiveRecord::Relation]
  scope :search, ->(keyword) {
    return all if keyword.blank?
    where("title LIKE ? OR description LIKE ?", "%#{keyword}%", "%#{keyword}%")
  }

  # ステータスで絞り込み
  #
  # @param status [String]
  # @return [ActiveRecord::Relation]
  scope :with_status, ->(status) {
    return all if status.blank?
    where(status: status)
  }

  # 優先度で絞り込み
  #
  # @param priority [String]
  # @return [ActiveRecord::Relation]
  scope :with_priority, ->(priority) {
    return all if priority.blank?
    where(priority: priority)
  }

  # --- Optional Validation --------------------------------------------------

  # 締切が未来かどうかをチェックする
  #
  # @return [void]
  # @note 現在は無効化されている
  # def deadline_must_be_future
  #   return if deadline.blank?
  #
  #   if deadline < Time.current
  #     errors.add(:deadline, "締め切りは現在より後の日時を設定してください")
  #   end
  # end
end
