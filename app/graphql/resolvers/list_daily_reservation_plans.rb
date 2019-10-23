class Resolvers::ListDailyReservationPlans < GraphQL::Function
  argument :search_start_at, !types.String
  argument :search_end_at, types.String

  type !types[Types::DailyReservationPlanListType]

  DailyReservationPlanList = Struct.new(
    'DailyReservationPlanList',
    :id,
    :effective_at,
    :reservation_plans
  )

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    search_start_at = DateTime.parse(args[:search_start_at]).beginning_of_day

    unless args[:search_end_at].nil?
      search_end_at = DateTime.parse(args[:search_end_at])
    else
      search_end_at = search_start_at.end_of_day
    end

    service = ::ReservationPlans::ReservationPlanRangeCalculator.new
    results = service.perform(
      restaurant: current_user.first_associated_restaurant,
      search_start_at: search_start_at,
      search_end_at: search_end_at,
    )

    modeled_results = results.entries.map do |key, value|
      DailyReservationPlanList.new(key, key, value)
    end

    return modeled_results
  end
end
