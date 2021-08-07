FactoryBot.define do
  factory :user do
    email { "testuser1@test.com" }
    password { 'password' }
    birthdate { DateTime.now + 2.months }
  end
end
