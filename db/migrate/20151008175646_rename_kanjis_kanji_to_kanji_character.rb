class RenameKanjisKanjiToKanjiCharacter < ActiveRecord::Migration
  def change
    rename_column(:kanji_comments, :kanji, :kanji_character)
  end
end
