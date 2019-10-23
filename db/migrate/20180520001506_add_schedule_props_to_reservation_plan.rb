class AddSchedulePropsToReservationPlan < ActiveRecord::Migration[5.1]
  def change
    add_column :reservation_plans, :repeat, :integer, default: 0, null: false
    add_column :reservation_plans, :effective_date_start_at, :timestamp
    add_column :reservation_plans, :effective_date_end_at, :timestamp
    add_column :reservation_plans, :active_weekday_0, :boolean, default: false, null: false
    add_column :reservation_plans, :active_weekday_1, :boolean, default: false, null: false
    add_column :reservation_plans, :active_weekday_2, :boolean, default: false, null: false
    add_column :reservation_plans, :active_weekday_3, :boolean, default: false, null: false
    add_column :reservation_plans, :active_weekday_4, :boolean, default: false, null: false
    add_column :reservation_plans, :active_weekday_5, :boolean, default: false, null: false
    add_column :reservation_plans, :active_weekday_6, :boolean, default: false, null: false
  end
end
