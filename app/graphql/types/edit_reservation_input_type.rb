Types::EditReservationInputType = GraphQL::InputObjectType.define do
  name 'EditReservationInput'

  argument :id, !types.ID
  argument :party_size, types.Int
  argument :party_notes, types.String
  argument :reservation_status, types.String
  argument :scheduled_start_at, types.String
  argument :seated_at, types.String
  argument :floor_plan_table_id, types.ID
  argument :tags, types.String
  argument :override_turn_time, types.Float
  argument :employee, types.String

end
