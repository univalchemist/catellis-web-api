class AddEmployeeToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :employee, :string
  end
end
