class MoveFloorPlanReservationStatusFromFloorPlansToFloorPlanTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :floor_plans, :floor_plan_reservation_status
    add_column :floor_plan_tables, :table_reservation_status, :string, default: ""
  end
end
