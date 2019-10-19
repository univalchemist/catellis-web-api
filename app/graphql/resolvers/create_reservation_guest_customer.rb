require 'query_support'

class Resolvers::CreateReservationGuestCustomer < GraphQL::Function
  Result = ImmutableStruct.new(:customer, :reservation)

  argument :restaurant_id, !types.ID
  argument :name, !types.String
  argument :phone_number, !types.String
  argument :email, types.String
  argument :scheduled_start_at, !types.String
  argument :party_size, !types.Int
  argument :party_notes, types.String
  argument :employee, types.String
  argument :tags, types.String

  # type Types::ReservationType
  type GraphQL::ObjectType.define do
    name 'CreateReservationGuestCustomer'

    field :customer, Types::CustomerType
    field :reservation, Types::ReservationType
  end

  def call(obj, args, ctx)
    # FIXME: this statement assumes that there is only a single restaurant
    #   in this system.

    restaurant = Restaurant.find(args[:restaurant_id])

    customers = Customer.where(restaurant: restaurant)
    matching_customers = customers
      .where(
        "name ILIKE :name",
        name: "%#{QuerySupport.sanitize_tokenize_like_input(args[:name])}%"
      )
      .or(
        customers.where(
          "phone_number ILIKE :phone_number",
          phone_number: "%#{QuerySupport.sanitize_phone_number(args[:phone_number])}%"
        )
      )
      .or(
        customers.where(
          "email ILIKE :email",
          email: "%#{args[:email]}%"
        )
      )

    customer = nil

    if matching_customers.count == 1
      normalized_name = QuerySupport.normalize_and_strip(args[:name]).downcase
      normalized_phone_number = QuerySupport.sanitize_phone_number(args[:phone_number])

      first_customer = matching_customers.first
      if first_customer.name.downcase == normalized_name && first_customer.phone_number == normalized_phone_number
        customer = first_customer
      end
    end

    if customer.nil?
      # FIXME: CreateCustomersService should be used here instead
      customer = Customer.create!(
        restaurant: restaurant,
        name: args[:name],
        phone_number: args[:phone_number],
        email: args[:email]
      )
    end

    # Create reservation.
    create_reservation_service = Reservations::CreateReservationService.new

    # FIXME: this arguments conversion should be in a shared superclass.
    # Clean up arguments.
    args_hash = args.to_h.deep_symbolize_keys

    restaurant_timezone = restaurant.local_timezone
    local_time = restaurant_timezone.utc_to_local(args_hash[:scheduled_start_at])
    available_times = restaurant.get_available_times(args_hash[:party_size], local_time.to_s)
        
    if available_times.include?(args_hash[:scheduled_start_at]&.to_time.strftime('%Y-%m-%dT%H:%M:%SZ'))
      create_params = args_hash.slice(:scheduled_start_at, :party_size, :party_notes, :employee, :tags)
      create_params[:reservation_status] = 'not_confirmed'

      create_reservation_result = create_reservation_service.perform(
        restaurant: restaurant,
        customer: customer,
        reservation_data: create_params
      )

      if customer.email
        NotificationMailer.send_confirmation_email(restaurant, customer, create_reservation_result).deliver
      end

      if restaurant.created_notification
        NotificationMailer.send_creation_reservation_alert_email(restaurant, customer, create_reservation_result).deliver
      end

      return Result.new(
        customer: customer,
        reservation: create_reservation_result.reservation
      )
    else
      GraphQL::ExecutionError.new("Time is not available")
    end
  end
end
