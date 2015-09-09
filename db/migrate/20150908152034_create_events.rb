class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.uuid :user_uuid
      t.text :payload

      t.timestamps null: false
    end

    add_index :events, :name
    add_index :events, :user_uuid
  end
end
