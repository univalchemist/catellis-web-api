require 'query_support'

class Reservations::ListReservationsService < BaseService
  Result = build_result_struct(:reservations)

  def perform(args:, ctx:)
    current_user = ctx[:current_user]

    scope = ::RestaurantScopePolicy::Scope.new(current_user, Reservation)
    reservations = scope.resolve
      .includes(:customer, :restaurant)

    unless args[:search_text].nil?
      search_values = QuerySupport.sanitize_tokenize_like_input(args[:search_text])

      reservations = reservations
        .joins(:customer)
        .where(
          "customers.name ILIKE :search_values",
          search_values: "%#{args[:search_text]}%"
        )
    end

    unless args[:category].nil?
      categories = args[:category]
      statuses = categories.map do |category|
        category = category.to_s

        case category
        when 'waitlist'
          next [:waitlist]
        when 'upcoming'
          next [:confirmed, :not_confirmed, :left_message, :no_answer, :wrong_number]
        when 'seated'
          next [:seated]
        when 'complete'
          next [:complete]
        end

        next []
      end

      statuses.flatten!

      reservations = reservations
        .where(reservation_status: statuses)
    end

    unless args[:scheduled_range_start_at].nil?
      scheduled_range_start_at = DateTime.parse(args[:scheduled_range_start_at])
      scheduled_range_end_at = scheduled_range_start_at + 24.hours

      unless args[:scheduled_range_end_at].nil?
        scheduled_range_end_at = DateTime.parse(args[:scheduled_range_end_at])
      end

      reservations = reservations
        .where(
          "scheduled_start_at < :scheduled_range_end_at AND scheduled_end_at > :scheduled_range_start_at",
          {
            scheduled_range_end_at: scheduled_range_end_at,
            scheduled_range_start_at: scheduled_range_start_at
          }
        )
    end

    unless args[:floor_plan_table_id].nil?
      reservations = reservations
        .where(floor_plan_table_id: args[:floor_plan_table_id])
    end

    reservations = reservations.order(scheduled_start_at: :asc)

    Result.new(
      success: true,
      reservations: reservations
    )
  end
end
