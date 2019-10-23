Types::ReservationPlanFloorPlanType = GraphQL::ObjectType.define do
  name 'ReservationPlanFloorPlan'

  field :id, !types.ID
  field :floor_plan, !Types::FloorPlanType
  field :reservation_plan, !Types::ReservationPlanType
end
