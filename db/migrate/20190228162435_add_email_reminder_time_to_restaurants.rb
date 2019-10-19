class AddEmailReminderTimeToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :email_reminder_time, :string
  end
end
