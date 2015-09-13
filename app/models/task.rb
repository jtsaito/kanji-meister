class Task < Struct.new(:kanji)
  def initialize(kanji)
    self.kanji = Kanji.first(:kanji, kanji)
  end

  def self.for_user(user, max = 5)
    events = Event.where(user_uuid: user.uuid, name: 'kanji_rendered')

    events.select { |e| e.payload.try(:[], "kanji_attributes").try(:[], "kanji").present? }
          .map { |e| e.payload["kanji_attributes"]["kanji"] }
          .uniq
          .sample(max)
          .map { |kanji| Task.new(kanji) }
  end
end
