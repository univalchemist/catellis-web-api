class CreateShiftNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :shift_notes do |t|
      t.references :restaurant, index: true, foreign_key: true, null: false
      t.references :author, index: true, foreign_key: { to_table: :users }, null: false
      t.timestamp :shift_start_at, null: false
      t.text :note

      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
