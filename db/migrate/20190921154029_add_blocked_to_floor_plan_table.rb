class AddBlockedToFloorPlanTable < ActiveRecord::Migration[5.1]
  def change
    add_column :floor_plan_tables, :blocked, :boolean, default: false
  end
end
