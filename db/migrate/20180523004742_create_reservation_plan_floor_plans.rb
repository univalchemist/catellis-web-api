class CreateReservationPlanFloorPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :reservation_plan_floor_plans do |t|
      t.references :reservation_plan, foreign_key: true, index: true
      t.references :floor_plan, foreign_key: true, index: true

      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
