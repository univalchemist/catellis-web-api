Types::FloorPlanTableType = GraphQL::ObjectType.define do
  name 'FloorPlanTable'

  field :id, !types.ID
  field :floor_plan_id, !types.ID
  field :floor_plan, !Types::FloorPlanType
  field :x, !types.Int
  field :y, !types.Int
  field :table_reservation_status, !types.String
  field :table_number, !types.String
  field :table_size, !types.Int
  field :table_type, !types.String
  field :table_shape, !types.String
  field :table_rotation, !types.Int
  field :min_covers, !types.Int
  field :max_covers, !types.Int
  field :blocked, !types.Boolean
  # TODO: This really belongs on an input type, rather than the data model type.
  field :_destroy, !types.Boolean
end
