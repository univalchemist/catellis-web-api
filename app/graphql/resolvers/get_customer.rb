class Resolvers::GetCustomer < GraphQL::Function
  argument :id, !types.ID

  type Types::CustomerType

  def call(obj, args, ctx)
    # FIXME: this should be retrofitted to use a service, like
    # GetReservationService does.
    Customer.find(args[:id])
  end
end
