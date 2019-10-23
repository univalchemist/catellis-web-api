class Resolvers::DestroyReservation < GraphQL::Function
  argument :id, !types.ID

  type Types::ReservationType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    reservations = ::RestaurantScopePolicy::Scope.new(current_user, Reservation).resolve
    reservation = reservations.find(args[:id])

    reservation.destroy

    reservation
  end
end
