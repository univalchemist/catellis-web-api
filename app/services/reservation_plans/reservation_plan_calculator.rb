class ReservationPlans::ReservationPlanCalculator < BaseService
  def perform(
    restaurant:,
    search_start_at:,
    search_end_at: search_start_at
  )
    scoped_rsvp_plans = ReservationPlan.where(restaurant: restaurant)

    matching_rsvp_plans = []

    normalized_search_start_at = DateTime.new(2000, search_start_at.month, search_start_at.day)
    normalized_search_end_at = DateTime.new(2000, search_end_at.month, search_end_at.day)

    matching_rsvp_plans.concat(
      active_day_of_week(
        reservation_plans: annually_scheduled_plans(
          reservation_plans: scoped_rsvp_plans,
          search_start_at: normalized_search_start_at
        ),
        search_start_at: search_start_at
      )
    )

    matching_rsvp_plans.concat(
      active_day_of_week(
        reservation_plans: specific_date_scheduled_plans(
          reservation_plans: scoped_rsvp_plans,
          search_start_at: search_start_at
        ),
        search_start_at: search_start_at
      )
    )

    override_plans = matching_rsvp_plans.select do |rsvp_plan|
      rsvp_plan.priority > 100
    end

    return override_plans unless override_plans.empty?

    return matching_rsvp_plans
  end

private

  def active_day_of_week(reservation_plans:, search_start_at:)
    weekday = search_start_at.wday

    reservation_plans
      .where(
        "active_weekday_#{weekday}" => true
      )
  end

  def annually_scheduled_plans(reservation_plans:, search_start_at:)
    annual_reservation_plans = reservation_plans
      .where(
        repeat: :annually,
      )

    date_range_query = "effective_date_start_at <= :normalized_search_start_at AND effective_date_end_at >= :normalized_search_start_at"

    annual_reservation_plans
      .where(
        date_range_query,
        {
          normalized_search_start_at: search_start_at
        }
      )
      .or(
        annual_reservation_plans.where(
          date_range_query,
          {
            normalized_search_start_at: DateTime.new(2001, search_start_at.month, search_start_at.day)
          }
        )
      )
  end

  def specific_date_scheduled_plans(reservation_plans:, search_start_at:)
    reservation_plans
      .where(
        repeat: :none,
      )
      .where(
        "effective_date_start_at <= :search_start_at AND effective_date_end_at >= :search_start_at",
        {
          search_start_at: search_start_at
        }
      )
  end

end
