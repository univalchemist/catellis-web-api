class Resolvers::DestroyCustomer < GraphQL::Function
  argument :id, !types.ID

  type Types::CustomerType

  def call(obj, args, ctx)
    customer = Customer.find(args[:id])

    customer.destroy!

    customer
  end
end
