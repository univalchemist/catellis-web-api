class AddFloorPlanTableReferenceToReservations < ActiveRecord::Migration[5.1]
  def change
    add_reference :reservations, :floor_plan_table, foreign_key: true
  end
end
