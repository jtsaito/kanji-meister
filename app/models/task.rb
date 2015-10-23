class Task < Struct.new(:kanji)
  def initialize(kanji = nil)
    self.kanji = kanji.is_a?(Kanji) ? kanji : Kanji.first(:kanji, kanji)
  end

  def self.for_user(user, only_new: false, max: 5)
    if only_new
      kanjis_not_reviewed(user).first(max)
    else
      kanjis_reviewed_earlier(user).sample(max)
    end
  end

  def <=>(other)
    kanji <=> other.kanji
  end

  def create_kanji_comment(user)
    attributes = { kanji_character: kanji.kanji, user_uuid: user.uuid }

    KanjiComment.where(attributes).first_or_create
  end

  private

  def self.kanjis_not_reviewed(user)
    reviewed_kanjis = kanjis_from_events(user).map { |k| Kanji.first(:kanji, k) }

    (Kanji.all - reviewed_kanjis).sort.map { |k| Task.new(k) }
  end

  def self.kanjis_reviewed_earlier(user)
    kanjis_from_events(user).map { |kanji| Task.new(kanji) }
  end

  def self.kanjis_from_events(user)
    Event.where(user_uuid: user.uuid, name: 'kanji_rendered')
         .select { |e| e.payload.try(:[], "kanji_attributes").try(:[], "kanji").present? }
         .map { |e| e.payload["kanji_attributes"]["kanji"] }
         .uniq
  end

end
