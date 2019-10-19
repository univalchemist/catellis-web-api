class Resolvers::ListAvailableReservationTimes < GraphQL::Function
  argument :restaurant_id, !types.ID
  argument :party_size, !types.Int
  argument :search_start_at, !types.String
  argument :search_end_at, types.String

  type !types[types.String]

  def call(obj, args, ctx)
    restaurant = Restaurant.find(args[:restaurant_id])
    times = restaurant.get_available_times(args[:party_size], args[:search_start_at], args[:search_end_at])

    return times
  end
end
