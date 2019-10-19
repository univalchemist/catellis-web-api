class Resolvers::GetReservationPlan < GraphQL::Function
  argument :id, !types.ID

  type Types::ReservationPlanType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurant = current_user.first_associated_restaurant

    reservation_plans = ::RestaurantScopePolicy::Scope.new(current_user, ReservationPlan).resolve
    reservation_plan = reservation_plans.find(args[:id])

    reservation_plan
  end
end
