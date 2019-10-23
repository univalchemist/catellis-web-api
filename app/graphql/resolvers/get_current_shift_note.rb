class Resolvers::GetCurrentShiftNote < GraphQL::Function
  argument :shift_start_at, !types.String
  argument :shift_end_at, !types.String

  type Types::ShiftNoteType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurant = current_user.first_associated_restaurant

    shift_notes = ::RestaurantScopePolicy::Scope.new(current_user, ShiftNote).resolve

    shift_start_at = DateTime.parse args[:shift_start_at]
    shift_end_at = DateTime.parse args[:shift_end_at]
    shift_notes = shift_notes
      .where(
        shift_start_at: (shift_start_at..shift_end_at)
      )

    shift_notes.first
  end
end
