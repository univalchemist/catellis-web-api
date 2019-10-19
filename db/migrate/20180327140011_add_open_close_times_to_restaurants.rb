class AddOpenCloseTimesToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :rest_open_at, :time, null: false, default: '10:00'
    add_column :restaurants, :rest_close_at, :time, null: false, default: '22:00'
  end
end
