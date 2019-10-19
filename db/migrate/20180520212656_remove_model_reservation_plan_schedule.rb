class RemoveModelReservationPlanSchedule < ActiveRecord::Migration[5.1]
  def change
    drop_table :reservation_plan_schedules
  end
end
