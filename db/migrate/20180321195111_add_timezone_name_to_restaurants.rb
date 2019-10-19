class AddTimezoneNameToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :timezone_name, :string, null: false
  end
end
