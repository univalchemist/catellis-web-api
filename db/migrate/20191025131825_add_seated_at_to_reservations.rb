class AddSeatedAtToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :seated_at, :string, default: ""
  end
end
