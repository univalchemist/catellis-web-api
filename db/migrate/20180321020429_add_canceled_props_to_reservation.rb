class AddCanceledPropsToReservation < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :canceled_at, :timestamp
    add_reference :reservations, :canceled_by, index: true, foreign_key: { to_table: :users }
  end
end
