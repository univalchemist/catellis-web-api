class AddCreatedNotificationToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :created_notification, :boolean, :default => true
  end
end
