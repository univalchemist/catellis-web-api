class Resolvers::EditReservation < GraphQL::Function
  argument :input, !Types::EditReservationInputType

  type Types::ReservationType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    reservations = ::RestaurantScopePolicy::Scope.new(current_user, Reservation).resolve
    reservation = reservations.find(args[:input][:id])
    # Create a copy of original state
    original_reservation = reservation.dup

    # Clean up arguments.
    args_hash = args[:input].to_h.deep_symbolize_keys
    update_params = args_hash
      .slice(
        :party_size,
        :scheduled_start_at,
        :scheduled_end_at,
        :seated_at,
        :party_notes,
        :reservation_status,
        :floor_plan_table_id,
        :employee,
        :tags,
        :override_turn_time
      )
    reservation.attributes = update_params

    if update_params[:scheduled_end_at].nil? || (update_params[:override_turn_time] && update_params[:override_turn_time] != reservation.override_turn_time)
      reservation.scheduled_end_at = reservation.scheduled_start_at + reservation.turn_time.hours
    end

    case reservation.reservation_status.to_sym
    when :seated
      if original_reservation.reservation_status_waitlist?
        # TODO: Clean this up... maybe some kind of notification event system?
        begin
          notification_service = Notifications::WaitlistToSeatedReservationNotification.new
          notification_service.perform(reservation: reservation)
        rescue Twilio::REST::RestError => error
        end
      end
    when :canceled_guest, :canceled_restaurant
      restaurant = Restaurant.find_by(id: reservation.restaurant_id)
      if restaurant.cancelled_notification
        NotificationMailer.send_cancelled_reservation_alert_email(restaurant, reservation).deliver
      end
      # TODO: Clean this up... maybe some kind of notification event system?
      begin
        notification_service = Notifications::CanceledReservationNotification.new
        notification_service.perform(reservation: reservation)
      rescue Twilio::REST::RestError => error
      end

      reservation.canceled_by = current_user
      reservation.canceled_at = Time.zone.now
    end
    changes = reservation.changes
    reservation.save!

    restaurant = Restaurant.find_by(id: reservation.restaurant_id)
    if reservation.reservation_status != "canceled_guest" || reservation.reservation_status != "canceled_restaurant"
      if restaurant.edited_notification
        NotificationMailer.send_edit_reservation_alert_email(restaurant, reservation, changes).deliver
      end
    end

    reservation
  end
end
