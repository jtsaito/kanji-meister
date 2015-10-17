FactoryGirl.define do
  factory :task do
    kanji { Kanji.all.first }
  end
end
