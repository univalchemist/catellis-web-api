class AddOnlineDaysInAdvanceToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :online_days_in_advance, :integer, default: 45
  end
end
