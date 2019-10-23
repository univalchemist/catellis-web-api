class Resolvers::ListFloorPlanTables < GraphQL::Function
  type !types[Types::FloorPlanTableType]

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurant = current_user.first_associated_restaurant

    floor_plans = ::RestaurantScopePolicy::Scope.new(current_user, FloorPlan).resolve

    floor_plan_tables = FloorPlanTable
      .where(floor_plan: floor_plans.to_a)

    floor_plan_tables
  end
end
