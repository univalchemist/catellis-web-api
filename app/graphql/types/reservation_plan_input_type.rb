Types::ReservationPlanInputType = GraphQL::InputObjectType.define do
  name 'ReservationPlanInput'

  argument :id, types.ID
  argument :name, !types.String
  argument :repeat, !types.String
  argument :priority, !types.Int
  argument :effective_time_start_at, !types.String
  argument :effective_time_end_at, !types.String
  argument :cust_reservable_start_at, !types.String
  argument :cust_reservable_end_at, !types.String
  argument :effective_date_start_at, !types.String
  argument :effective_date_end_at, !types.String
  argument :active_weekday_0, !types.Boolean
  argument :active_weekday_1, !types.Boolean
  argument :active_weekday_2, !types.Boolean
  argument :active_weekday_3, !types.Boolean
  argument :active_weekday_4, !types.Boolean
  argument :active_weekday_5, !types.Boolean
  argument :active_weekday_6, !types.Boolean
  argument :reservation_plan_floor_plans_attributes, types[Types::ReservationPlanFloorPlanInputType]
end
