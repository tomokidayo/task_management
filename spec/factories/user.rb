FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    email { Faker::Internet.email }
    password { "password" }
  end
end
