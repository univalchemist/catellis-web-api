class AddKitchenPacingToRestaurant < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :kitchen_pacing, :integer
  end
end
