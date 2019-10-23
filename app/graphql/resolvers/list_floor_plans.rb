class Resolvers::ListFloorPlans < GraphQL::Function
  type !types[Types::FloorPlanType]

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurant = current_user.first_associated_restaurant

    floor_plans = ::RestaurantScopePolicy::Scope.new(current_user, FloorPlan).resolve

    floor_plans
  end
end
