class ReservationPlans::ReservationPlanRangeCalculator < BaseService
  def perform(
    restaurant:,
    search_start_at:,
    search_end_at: search_start_at.end_of_day
  )
    all_results = {}
    search_end_at = search_end_at.end_of_day
    current_search_at = search_start_at
    reservation_plan_calculator_service = ReservationPlans::ReservationPlanCalculator.new

    while current_search_at < search_end_at do
      day_result = reservation_plan_calculator_service.perform(
        restaurant: restaurant,
        search_start_at: current_search_at,
      )

      all_results[current_search_at] = day_result

      current_search_at = current_search_at + 1.day
    end

    return all_results
  end
end
