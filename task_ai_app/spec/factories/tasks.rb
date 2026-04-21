FactoryBot.define do
  factory :task do
    association :user
    title { "テストタスク" }
    description { "説明文" }
    status { :not_started }
    priority { :low }
    deadline { 1.hour.from_now }
    estimated_time { 60 }
    actual_time { 30 }
  end
end
