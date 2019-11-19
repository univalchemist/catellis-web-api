Types::FloorPlanInputType = GraphQL::InputObjectType.define do
  name 'FloorPlanInput'

  argument :id, types.ID
  argument :name, types.String
  argument :floor_plan_reservation_status, types.String
  argument :floor_plan_tables_attributes, types[Types::FloorPlanTableInputType]
end
