Types::ShiftNoteType = GraphQL::ObjectType.define do
  name 'ShiftNote'

  field :id, !types.ID
  field :restaurant, !Types::RestaurantType
  field :author, !Types::UserType
  # TODO: this should be a custom Scalar.
  field :shift_start_at, !types.String do
    resolve ->(obj, args, ctx) {
      obj.shift_start_at.iso8601
    }
  end
  field :note, types.String
end
