class Resolvers::EditCustomer < GraphQL::Function
  argument :id, !types.ID
  argument :name, types.String
  argument :phone_number, types.String
  argument :email, types.String
  argument :tags, types.String

  type Types::CustomerType

  def call(obj, args, ctx)
    customer = Customer.find(args[:id])

    # Clean up arguments.
    args_hash = args.to_h.deep_symbolize_keys
    update_params = args_hash.slice(:name, :phone_number, :email, :tags)

    customer.update!(update_params)

    customer
  end
end
