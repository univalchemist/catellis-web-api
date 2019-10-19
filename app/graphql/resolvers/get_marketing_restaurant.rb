class Resolvers::GetMarketingRestaurant < GraphQL::Function
  type Types::RestaurantType

  def call(obj, args, ctx)
    restaurant = Restaurant.first

    restaurant
  end
end
