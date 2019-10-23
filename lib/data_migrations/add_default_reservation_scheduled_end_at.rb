module DataMigrations
  class AddDefaultReservationScheduledEndAt
    def change
      ActiveRecord::Base.transaction do
        candidate_reservations = Reservation.where(scheduled_end_at: nil)

        candidate_reservations.each do |reservation|
          candidate_reservations.update(
            scheduled_end_at: reservation.scheduled_start_at + 90.minutes
          )
        end
      end
    end
  end
end
