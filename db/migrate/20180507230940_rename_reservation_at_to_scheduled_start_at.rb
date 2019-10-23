require 'data_migrations/add_default_reservation_scheduled_end_at'

class RenameReservationAtToScheduledStartAt < ActiveRecord::Migration[5.1]
  def up
    rename_column :reservations, :reservation_at, :scheduled_start_at
    add_column :reservations, :scheduled_end_at, :datetime

    DataMigrations::AddDefaultReservationScheduledEndAt.new.change

    change_column_null :reservations, :scheduled_end_at, false
  end

  def down
    remove_column :reservations, :scheduled_end_at
    rename_column :reservations, :scheduled_start_at, :reservation_at
  end
end
