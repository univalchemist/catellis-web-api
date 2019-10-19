class AddNotificationEmailAddressToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :notification_email_address, :string
  end
end
