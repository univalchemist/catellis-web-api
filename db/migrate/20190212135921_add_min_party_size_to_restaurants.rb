class AddMinPartySizeToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :min_party_size, :integer, default: 1
  end
end
