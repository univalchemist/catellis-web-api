class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.references :restaurant, index: true, foreign_key: true
      t.references :customer, index: true, foreign_key: true
      t.timestamp :reservation_at, null: false
      t.integer :party_size
      t.text :party_notes
      t.integer :reservation_status, null: false, default: 0

      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
