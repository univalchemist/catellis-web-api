class AddOnlineToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :online, :boolean, default: false
  end
end
