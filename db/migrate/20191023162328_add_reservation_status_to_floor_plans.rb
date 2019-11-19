class AddReservationStatusToFloorPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :floor_plans, :floor_plan_reservation_status, :string, default: ""
  end
end
