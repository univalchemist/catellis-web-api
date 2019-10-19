class Resolvers::ListCustomers < GraphQL::Function
  argument :search_text, types.String

  type !types[Types::CustomerType]

  def call(obj, args, ctx)
    ::GraphQlServiceAdapter.perform(
      Customers::ListCustomersService,
      :customers,
      args,
      ctx
    )
  end
end
