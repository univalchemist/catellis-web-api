class AddEditedNotificationToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :edited_notification, :boolean, :default => true
  end
end
