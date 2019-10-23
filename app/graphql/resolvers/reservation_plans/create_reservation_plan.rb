require 'resolvers/reservation_plans'

class Resolvers::ReservationPlans::CreateReservationPlan < GraphQL::Function
  argument :input, !Types::ReservationPlanInputType

  type Types::ReservationPlanType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurant = current_user.first_associated_restaurant

    # FIXME: this arguments conversion should be in a shared superclass.
    # Clean up arguments.
    args_hash = args[:input].to_h.deep_symbolize_keys
    create_params = Resolvers::ReservationPlans.build_args(args_hash)

    reservation_plan = ReservationPlan.create(
      restaurant: restaurant,
      **create_params
    )

    reservation_plan
  end
end
