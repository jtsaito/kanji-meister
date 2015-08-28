FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user_#{i}@kanji-meister.com" }
    password { SecureRandom.hex }
  end
end
