require 'query_support'

class Resolvers::DestroyReservationPlan < GraphQL::Function
  argument :id, !types.ID

  type Types::ReservationPlanType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    reservation_plans = ::RestaurantScopePolicy::Scope.new(current_user, ReservationPlan).resolve
    reservation_plan = reservation_plans.find(args[:id])

    reservation_plan.destroy

    reservation_plan
  end
end
