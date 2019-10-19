class Resolvers::GetCurrentRestaurant < GraphQL::Function
  type Types::RestaurantType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurant = current_user.first_associated_restaurant

    restaurant
  end
end
