require 'query_support'

class Resolvers::CreateFloorPlan < GraphQL::Function
  argument :input, !Types::FloorPlanInputType

  type Types::FloorPlanType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurant = current_user.first_associated_restaurant

    # FIXME: this arguments conversion should be in a shared superclass.
    # Clean up arguments.
    args_hash = args[:input].to_h.deep_symbolize_keys
    create_params = args_hash.slice(:name, :floor_plan_tables_attributes)
    create_params[:floor_plan_tables_attributes] = create_params[:floor_plan_tables_attributes].map do |attributes|
      attributes.slice(
        :id,
        :x,
        :y,
        :table_number,
        :table_size,
        :table_shape,
        :table_type,
        :table_rotation,
        :min_covers,
        :max_covers,
        :_destroy
      )
    end

    result = FloorPlan.create(
      restaurant: restaurant,
      **create_params
    )

    result
  end
end
