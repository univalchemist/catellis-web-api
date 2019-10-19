class Resolvers::GetFloorPlanTable < GraphQL::Function
  argument :id, !types.ID

  type Types::FloorPlanTableType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurant = current_user.first_associated_restaurant

    floor_plan_tables = FloorPlanTable
      .joins(:floor_plan)
      .where(
        floor_plans: {
          restaurant: restaurant
        }
      )

    floor_plan_table = floor_plan_tables.find(args[:id])

    floor_plan_table
  end
end
