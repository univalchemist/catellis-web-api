class Resolvers::GetReservation < GraphQL::Function
  argument :id, !types.ID

  type Types::ReservationType

  def call(obj, args, ctx)
    ::GraphQlServiceAdapter.perform(
      Reservations::GetReservationService,
      :reservation,
      args,
      ctx
    )
  end
end
