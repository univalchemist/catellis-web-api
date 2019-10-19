class AddOverrideTurnTimeToReservation < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :override_turn_time, :float
  end
end
