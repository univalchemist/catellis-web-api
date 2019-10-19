class CreateFloorPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :floor_plans do |t|
      t.references :restaurant, index: true, foreign_key: true
      t.string :name, null: false

      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
