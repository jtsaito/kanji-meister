class CreateKanjiComments < ActiveRecord::Migration
  def change
    create_table :kanji_comments do |t|
      t.uuid :user_uuid, limit: 16
      t.string :kanji, limimt: 1
      t.text :text

      t.timestamps null: false
    end

    add_index :kanji_comments, [:user_uuid, :kanji], unique: true
  end
end
