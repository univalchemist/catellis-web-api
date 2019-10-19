class Resolvers::CreateShiftNote < GraphQL::Function
  argument :shift_start_at, !types.String
  argument :note, !types.String

  type Types::ShiftNoteType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurant = current_user.first_associated_restaurant

    shift_note = ShiftNote.create!(
      restaurant: restaurant,
      author: current_user,
      note: args[:note],
      shift_start_at: DateTime.parse(args[:shift_start_at])
    )

    shift_note
  end
end
