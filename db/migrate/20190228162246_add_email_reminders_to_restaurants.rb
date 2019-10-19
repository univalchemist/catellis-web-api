class AddEmailRemindersToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :email_reminders, :boolean, :default => true
  end
end
