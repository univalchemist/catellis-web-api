class AddCancelledNotificationToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :cancelled_notification, :boolean, :default => true
  end
end
