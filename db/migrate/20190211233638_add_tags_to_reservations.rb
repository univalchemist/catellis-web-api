class AddTagsToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :tags, :string
  end
end
