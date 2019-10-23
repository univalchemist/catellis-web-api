require 'query_support'

class Resolvers::DestroyFloorPlan < GraphQL::Function
  argument :id, !types.ID

  type Types::FloorPlanType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    floor_plans = ::RestaurantScopePolicy::Scope.new(current_user, FloorPlan).resolve
    floor_plan = floor_plans.find(args[:id])

    floor_plan.destroy

    floor_plan
  end
end
