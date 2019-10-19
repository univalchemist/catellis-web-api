class Resolvers::ListReservations < GraphQL::Function
  argument :search_text, types.String
  argument :category, types.String
  argument :scheduled_range_start_at, types.String
  argument :scheduled_range_end_at, types.String
  argument :floor_plan_table_id, types.ID

  type !types[Types::ReservationType]

  def call(obj, args, ctx)
    sanitized_args = args.to_h
      .deep_symbolize_keys
      .slice(
        :search_text,
        :category,
        :scheduled_range_start_at,
        :scheduled_range_end_at,
        :floor_plan_table_id
      )

    sanitized_args[:category] = sanitized_args[:category].split(',')

    ::GraphQlServiceAdapter.perform(
      Reservations::ListReservationsService,
      :reservations,
      sanitized_args,
      ctx
    )
  end
end
