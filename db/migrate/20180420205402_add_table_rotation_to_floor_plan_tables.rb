class AddTableRotationToFloorPlanTables < ActiveRecord::Migration[5.1]
  def change
    add_column :floor_plan_tables, :table_rotation, :integer, default: 0, null: false
  end
end
