FactoryGirl.define do

  factory :event do
    name "MyString"
    user nil
    payload {}

    trait :kanji_rendered do
      name "kanji_rendered"
      payload { { kanji_attributes: Kanji.first(:kanji, "鑑").to_h } }
    end
  end

end
