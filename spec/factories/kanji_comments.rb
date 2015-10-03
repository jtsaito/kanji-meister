FactoryGirl.define do
  factory :kanji_comment do
    user { create(:user) }
    kanji Kanji.all.first
    text "Some comment"
  end
end
