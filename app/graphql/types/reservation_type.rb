Types::ReservationType = GraphQL::ObjectType.define do
  name 'Reservation'

  field :id, !types.ID
  field :customer, !Types::CustomerType
  field :restaurant, !Types::RestaurantType
  field :floor_plan_table, Types::FloorPlanTableType
  # TODO: this should be a custom Scalar.
  field :scheduled_start_at, !types.String do
    resolve ->(obj, args, ctx) {
      obj.scheduled_start_at.iso8601
    }
  end
  # TODO: this should be a custom Scalar.
  field :scheduled_end_at, !types.String do
    resolve ->(obj, args, ctx) {
      obj.scheduled_end_at.iso8601
    }
  end
  field :party_size, !types.Int
  field :party_notes, types.String
  field :reservation_status, !types.String
  field :table_conflicted, types.Boolean, function: Resolvers::Fields::ReservationTableConflicted.new
  field :deleted_at, types.String
  field :employee, types.String
  field :tags, types.String
  field :override_turn_time, types.Float
end
