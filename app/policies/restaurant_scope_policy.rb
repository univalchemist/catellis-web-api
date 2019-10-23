class RestaurantScopePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:app_admin)
        scope.all
      else
        associated_restaurant = user.first_associated_restaurant
        scope.where(restaurant: associated_restaurant)
      end
    end
  end

protected

  def restaurant
    record.restaurant
  end
end
