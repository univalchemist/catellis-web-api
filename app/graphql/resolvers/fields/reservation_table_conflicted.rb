class Resolvers::Fields::ReservationTableConflicted < GraphQL::Function
  def call(reservation, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    reservations = ::RestaurantScopePolicy::Scope.new(current_user, Reservation).resolve

    # If the reservation has no assigned table, then it cannot have a table
    # conflict.
    return false if reservation.floor_plan_table.nil?

    # If the reservation is inacitve, is cannot have a table conflict.
    return false if reservation.inactive_status?

    # Reservation has an assigned table, check for other overlapping
    # reservations to see if any have the same table assignment.
    conflicting_reservations = reservations
      .where.not(id: reservation.id)
      .where(
        floor_plan_table_id: reservation.floor_plan_table_id,
        reservation_status: Reservation.ACTIVE_STATUSES,
      )
      .where(
        "scheduled_start_at < :scheduled_range_end_at AND scheduled_end_at > :scheduled_range_start_at",
        {
          scheduled_range_end_at: reservation.scheduled_end_at,
          scheduled_range_start_at: reservation.scheduled_start_at
        }
      )

    return conflicting_reservations.count > 0
  end
end
