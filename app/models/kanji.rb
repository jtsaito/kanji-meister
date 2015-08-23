class Kanji < Struct.new(:heisig_id, :kanji, :key_word, :stroke_count, :index_ordinal, :heisig_lesson)

  @@all = nil

  def self.all
    @@all ||=
      YAML.load(File.read(KanjiDataPath)).map do |h|
        Kanji.new(*Kanji.members.map { |m| h.fetch(m) })
      end.sort
  end

  def self.first(member, value)
    by(member,value).first
  end

  def self.by(member, value)
    raise UnknownAttributeError if Kanji.members.exclude?(member)
    all.select { |kanji| kanji[member] == value.to_s }
  end

  def <=>(other)
    heisig_id.to_i <=> other.heisig_id.to_i
  end

  class UnknownAttributeError < StandardError; end
end
