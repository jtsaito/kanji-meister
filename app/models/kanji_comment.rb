class KanjiComment < ActiveRecord::Base

  include ActiveUUID::UUID

  belongs_to :user, foreign_key: :user_uuid, primary_key: :uuid

  validates :user, presence: true
  validates :kanji_character, presence: true, uniqueness: true
  validate  :kanji_character_must_be_known

  private

  def kanji_character_must_be_known
    if Kanji.first(:kanji, kanji_character).blank?
      errors.add(:kanji_character, "must be known Kanji")
    end
  end

end
