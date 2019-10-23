class Resolvers::CreateCustomer < GraphQL::Function
  argument :name, !types.String
  argument :phone_number, !types.String
  argument :email, types.String
  argument :tags, types.String

  type Types::CustomerType

  def call(obj, args, ctx)
    service = Customers::CreateCustomersService.new

    result = service.perform(
      args: args,
      ctx: ctx
    )

    result.customer
  end
end
