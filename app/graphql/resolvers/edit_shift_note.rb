class Resolvers::EditShiftNote < GraphQL::Function
  argument :id, !types.ID
  argument :note, !types.String

  type Types::ShiftNoteType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    shift_notes = ::RestaurantScopePolicy::Scope.new(current_user, ShiftNote).resolve
    shift_note = shift_notes.find(args[:id])

    # Clean up arguments.
    args_hash = args.to_h.deep_symbolize_keys
    update_params = args_hash.slice(:note)

    shift_note.update!(update_params)

    shift_note
  end
end
