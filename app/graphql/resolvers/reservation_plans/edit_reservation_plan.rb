require 'resolvers/reservation_plans'

class Resolvers::ReservationPlans::EditReservationPlan < GraphQL::Function
  argument :input, !Types::ReservationPlanInputType

  type Types::ReservationPlanType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    reservation_plans = ::RestaurantScopePolicy::Scope.new(current_user, ReservationPlan).resolve
    reservation_plan = reservation_plans.find(args[:input][:id])

    # FIXME: this arguments conversion should be in a shared superclass.
    # Clean up arguments.
    args_hash = args[:input].to_h.deep_symbolize_keys
    update_params = ::Resolvers::ReservationPlans.build_args(args_hash)

    reservation_plan.attributes = update_params
    reservation_plan.save!

    reservation_plan
  end
end
