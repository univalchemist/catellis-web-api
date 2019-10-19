class AddMaxPartySizeToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :max_party_size, :integer, default: 10
  end
end
