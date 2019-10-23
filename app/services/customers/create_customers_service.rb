class Customers::CreateCustomersService < BaseService
  Result = build_result_struct(:customer)

  def perform(args:, ctx:)
    current_user = ctx[:current_user]

    customer = nil
    ActiveRecord::Base.transaction do
      customer = Customer.create!(
        restaurant: current_user.first_associated_restaurant,
        name: args[:name],
        phone_number: args[:phone_number],
        email: args[:email],
        tags: args[:tags]
      )
    end

    Result.new(
      success: true,
      customer: customer
    )
  end
end
