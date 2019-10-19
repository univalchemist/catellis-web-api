class CreateReservationPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :reservation_plans do |t|
      t.references :restaurant, index: true, foreign_key: true
      t.string :name, null: false
      t.integer :priority, null: false, default: 100

      t.integer :effective_date_start_at_day
      t.integer :effective_date_start_at_month
      t.integer :effective_date_end_at_day
      t.integer :effective_date_end_at_month
      # t.timestamp :effective_date_start_at
      # t.timestamp :effective_date_end_at
      t.time :effective_time_start_at, null: false
      t.time :effective_time_end_at, null: false
      t.time :cust_reservable_start_at, null: false
      t.time :cust_reservable_end_at, null: false

      t.timestamp :deleted_at
      t.timestamps
    end

    create_table :reservation_plan_schedules do |t|
      t.references :reservation_plan, index: true, foreign_key: true

      t.integer :repeat, default: 0, null: false
      t.integer :annual_day
      t.integer :annual_month
      t.timestamp :effective_date_start_at
      t.timestamp :effective_date_end_at
      t.boolean :active_day_of_week, default: false, null: false
      # These weekday indices match the values returned by DateTime#wday.
      # E.g.: 0 - Sunday, 6 - Saturday.
      t.boolean :active_weekday_0, default: false, null: false
      t.boolean :active_weekday_1, default: false, null: false
      t.boolean :active_weekday_2, default: false, null: false
      t.boolean :active_weekday_3, default: false, null: false
      t.boolean :active_weekday_4, default: false, null: false
      t.boolean :active_weekday_5, default: false, null: false
      t.boolean :active_weekday_6, default: false, null: false

      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
