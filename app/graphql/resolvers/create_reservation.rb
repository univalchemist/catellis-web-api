class Resolvers::CreateReservation < GraphQL::Function
  argument :customer_id, !types.ID
  argument :scheduled_start_at, !types.String
  argument :party_size, !types.Int
  argument :party_notes, types.String
  argument :reservation_status, !types.String
  argument :floor_plan_table_id, types.ID
  argument :employee, types.String
  argument :tags, types.String

  type Types::ReservationType

  def initialize(create_reservation_service: nil)
    @create_reservation_service = (
      create_reservation_service || ::Reservations::CreateReservationService.new
    )
  end

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurant = current_user.first_associated_restaurant

    customers = ::RestaurantScopePolicy::Scope.new(current_user, Customer).resolve
    customer = customers.find(args[:customer_id])


    # Clean up arguments.
    args_hash = args.to_h.deep_symbolize_keys
    create_params = args_hash.slice(
      :scheduled_start_at,
      :party_size,
      :party_notes,
      :reservation_status,
      :floor_plan_table_id,
      :employee,
      :tags
    )

    reservation = nil

    result = @create_reservation_service.perform(
      restaurant: restaurant,
      customer: customer,
      reservation_data: create_params
    )

    raise result.error unless result.success

    if restaurant.email_confirmation_inhouse
      NotificationMailer.send_inhouse_confirmation_email(restaurant, customer, result).deliver
    end

    if restaurant.created_notification
      NotificationMailer.send_creation_reservation_alert_email(restaurant, customer, result).deliver
    end

    result.reservation
  end

protected

  attr_reader :create_reservation_service
end
