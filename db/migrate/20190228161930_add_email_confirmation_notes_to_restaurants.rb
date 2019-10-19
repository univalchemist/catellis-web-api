class AddEmailConfirmationNotesToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :email_confirmation_notes, :text
  end
end
