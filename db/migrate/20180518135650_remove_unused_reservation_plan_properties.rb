class RemoveUnusedReservationPlanProperties < ActiveRecord::Migration[5.1]
  def change
    # ReservationPlan cleanup
    remove_column :reservation_plans, :effective_date_start_at_day, :integer
    remove_column :reservation_plans, :effective_date_start_at_month, :integer
    remove_column :reservation_plans, :effective_date_end_at_day, :integer
    remove_column :reservation_plans, :effective_date_end_at_month, :integer

    # ReservationPlanSchedule cleanup
    remove_column :reservation_plan_schedules, :annual_day, :integer
    remove_column :reservation_plan_schedules, :annual_month, :integer
  end
end
