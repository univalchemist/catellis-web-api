Types::FloorPlanTableInputType = GraphQL::InputObjectType.define do
  name 'FloorPlanTableInput'

  argument :id, types.ID
  argument :x, types.Int
  argument :y, types.Int
  argument :table_number, types.String
  argument :table_size, types.Int
  argument :table_shape, types.String
  argument :table_type, types.String
  argument :table_rotation, types.Int
  argument :min_covers, types.Int
  argument :max_covers, types.Int
  argument :blocked, types.Boolean
  argument :_destroy, types.Boolean
end
