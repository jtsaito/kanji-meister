FactoryGirl.define do
  factory :kanji_comment do
    user { create(:user) }
    kanji_character Kanji.all.first.kanji
    text "Some comment"
  end
end
