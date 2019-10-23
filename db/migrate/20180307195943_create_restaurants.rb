class CreateRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
