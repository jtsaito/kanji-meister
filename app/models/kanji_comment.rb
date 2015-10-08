class KanjiComment < ActiveRecord::Base

  include ActiveUUID::UUID

  belongs_to :user, foreign_key: :user_uuid, primary_key: :uuid

  validates :user, presence: true
  validates :kanji_character, presence: true

end
