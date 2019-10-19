require 'query_support'

class Resolvers::CreateReservationFuzzyCustomer < GraphQL::Function
  Result = ImmutableStruct.new(:status, :suggested_customers, :reservation)

  argument :name, !types.String
  argument :phone_number, !types.String
  argument :scheduled_start_at, !types.String
  argument :party_size, !types.Int
  argument :party_notes, types.String
  argument :reservation_status, !types.String
  argument :employee, types.String
  argument :tags, types.String

  # type Types::ReservationType
  type GraphQL::ObjectType.define do
    name 'CreateReservationFuzzyCustomer'

    field :status, !types.String
    field :suggested_customers, types[Types::CustomerType]
    field :reservation, Types::ReservationType
  end

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurant = current_user.first_associated_restaurant

    customers = ::RestaurantScopePolicy::Scope.new(current_user, Customer).resolve
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

    customer = nil

    if matching_customers.count == 1
      normalized_name = QuerySupport.normalize_and_strip(args[:name]).downcase
      normalized_phone_number = QuerySupport.sanitize_phone_number(args[:phone_number])

      first_customer = matching_customers.first
      if first_customer.name.downcase == normalized_name && first_customer.phone_number == normalized_phone_number
        customer = first_customer
      end
    end

    if customer
      # Create reservation.
      create_reservation_service = Resolvers::CreateReservation.new

      # FIXME: this arguments conversion should be in a shared superclass.
      # Clean up arguments.
      args_hash = args.to_h.deep_symbolize_keys
      create_params = args_hash.slice(:scheduled_start_at, :party_size, :party_notes, :reservation_status, :employee, :tags)
      create_params = args_hash.slice(:scheduled_start_at, :party_size, :party_notes, :reservation_status, :tags)

      reservation = create_reservation_service.call(
        obj,
        {
          customer_id: matching_customers.first.id,
          **create_params
        },
        ctx
      )

      return Result.new(
        status: :reservation_created,
        suggested_customers: matching_customers,
        reservation: reservation
      )
    end

    # Return suggested customers.
    return Result.new(
      status: :no_exact_match,
      suggested_customers: matching_customers,
      reservation: nil
    )
  end
end
