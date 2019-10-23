class Reservations::GetReservationService < BaseService
  Result = build_result_struct(:reservation)

  def perform(args:, ctx:)
    current_user = ctx[:current_user]

    scope = ::RestaurantScopePolicy::Scope.new(current_user, Reservation)
    reservations = scope.resolve

    begin
      reservation = reservations.find(args[:id])
    rescue ActiveRecord::RecordNotFound => error
      return error_result(error)
    end

    Result.new(
      success: true,
      reservation: reservation
    )
  end
end
