class CreateFloorPlanTables < ActiveRecord::Migration[5.1]
  def change
    create_table :floor_plan_tables do |t|
      t.references :floor_plan, index: true, foreign_key: true
      t.integer :x, default: 0, null: false
      t.integer :y, default: 0, null: false

      t.string :table_number, null: false
      t.integer :table_size, default: 0, null: false
      t.integer :table_type, default: 0, null: false
      t.integer :table_shape, default: 0, null: false
      t.integer :min_covers, default: 0, null: false
      t.integer :max_covers, default: 0, null: false

      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
