class AddEmailConfirmationInhouseToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :email_confirmation_inhouse, :boolean, :default => true
  end
end
