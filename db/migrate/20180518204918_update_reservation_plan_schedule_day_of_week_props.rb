class UpdateReservationPlanScheduleDayOfWeekProps < ActiveRecord::Migration[5.1]
  def change
    remove_column :reservation_plan_schedules, :active_day_of_week, :boolean

    # rename_column :reservation_plan_schedules, :active_weekday_0, :active_weekday_0, default: true, null: false
  end
end
