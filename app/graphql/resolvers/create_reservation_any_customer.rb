require 'query_support'

class Resolvers::CreateReservationAnyCustomer < GraphQL::Function
  Result = ImmutableStruct.new(:customer, :reservation)

  argument :restaurant_id, !types.ID
  argument :name, !types.String
  argument :phone_number, !types.String
  argument :email, types.String
  argument :scheduled_start_at, !types.String
  argument :seated_at, !types.String
  argument :party_size, !types.Int
  argument :party_notes, types.String
  argument :employee, types.String
  argument :tags, types.String
  argument :floor_plan_table_id, !types.ID

  # type Types::ReservationType
  type GraphQL::ObjectType.define do
    name 'CreateReservationAnyCustomer'

    field :customer, Types::CustomerType
    field :reservation, Types::ReservationType
  end

  def call(obj, args, ctx)
    # FIXME: this statement assumes that there is only a single restaurant
    #   in this system.

    restaurant = Restaurant.find(args[:restaurant_id])
    customer = nil
    if args[:name] == "Anonymous"
      anoCustomers = Customer.where(name: "Anonymous")
      if anoCustomers.count > 0
        customer = anoCustomers.first
      else
        customer = Customer.create!(
            restaurant: restaurant,
            name: args[:name],
            phone_number: args[:phone_number],
            email: args[:email]
        )
      end
    else
      customers = Customer.where(name: args[:name]).where(phone_number: args[:phone_number])
      if customers.count > 0
        normalized_name = QuerySupport.normalize_and_strip(args[:name]).downcase
        normalized_phone_number = QuerySupport.sanitize_phone_number(args[:phone_number])

        first_customer = customers.first
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
    end

    # Create reservation.
    create_reservation_service = Reservations::CreateReservationService.new

    # FIXME: this arguments conversion should be in a shared superclass.
    # Clean up arguments.
    args_hash = args.to_h.deep_symbolize_keys

    create_params = args_hash.slice(:scheduled_start_at, :seated_at, :floor_plan_table_id, :party_size, :party_notes, :employee, :tags)
    create_params[:reservation_status] = 'seated'

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
  end
end
