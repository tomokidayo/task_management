class Task < ApplicationRecord
  belongs_to :user
  before_validation :convert_times_to_minutes

  enum status: {
    not_started: 0,
    in_progress: 1,
    completed: 2
  }

  enum priority: {
    low: 0,
    medium: 1,
    high: 2
  }

  PRIORITY_LABELS = {
    "low" => "通常",
    "medium" => "優先",
    "high" => "緊急"
  }.freeze

  STATUS_LABELS = {
    "not_started" => "未着手",
    "in_progress" => "進行中",
    "completed" => "完了"
  }.freeze

  def priority_label
    PRIORITY_LABELS[priority]
  end

  def status_label
    STATUS_LABELS[status]
  end

  def convert_times_to_minutes
    self.estimated_time = hhmm_to_minutes(estimated_time)
    self.actual_time = hhmm_to_minutes(actual_time)
  end

  def hhmm_to_minutes(value)
    return value if value.is_a?(Integer)
    return nil if value.blank?
    h, m = value.split(":").map(&:to_i)
    h * 60 + m
  end

  def minutes_to_hhmm(minutes)
    return nil if minutes.nil?
    format("%02d:%02d", minutes / 60, minutes % 60)
  end

  def estimated_time_hhmm
    minutes_to_hhmm(estimated_time)
  end

  def actual_time_hhmm
    minutes_to_hhmm(actual_time)
  end

  scope :search, ->(keyword) {
    return all if keyword.blank?
    where("title LIKE ? OR description LIKE ?", "%#{keyword}%", "%#{keyword}%")
  }

  scope :with_status, ->(status) {
    return all if status.blank?
    where(status: status)
  }

  scope :with_priority, ->(priority) {
    return all if priority.blank?
    where(priority: priority)
  }
end
