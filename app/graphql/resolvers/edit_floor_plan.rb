require 'query_support'

class Resolvers::EditFloorPlan < GraphQL::Function
  argument :input, !Types::FloorPlanInputType

  type Types::FloorPlanType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    floor_plans = ::RestaurantScopePolicy::Scope.new(current_user, FloorPlan).resolve
    floor_plan = floor_plans.find(args[:input][:id])

    # FIXME: this arguments conversion should be in a shared superclass.
    # Clean up arguments.
    args_hash = args[:input].to_h.deep_symbolize_keys
    update_params = args_hash.slice(:name, :floor_plan_tables_attributes)
    update_params[:floor_plan_tables_attributes] = update_params[:floor_plan_tables_attributes].map do |attributes|
      attributes.slice(
        :id,
        :x,
        :y,
        :table_reservation_status,
        :table_number,
        :table_size,
        :table_shape,
        :table_type,
        :table_rotation,
        :min_covers,
        :max_covers,
        :blocked,
        :_destroy
      )
    end

    floor_plan.attributes = update_params
    floor_plan.save!

    floor_plan
  end
end
