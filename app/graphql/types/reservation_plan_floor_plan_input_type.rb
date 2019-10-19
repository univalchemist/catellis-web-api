Types::ReservationPlanFloorPlanInputType = GraphQL::InputObjectType.define do
  name 'ReservationPlanFloorPlanInput'

  argument :id, types.ID
  argument :floor_plan_id, types.ID
  argument :_destroy, types.Boolean
end
