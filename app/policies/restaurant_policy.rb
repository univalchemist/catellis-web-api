class RestaurantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role?(:app_admin)
        scope.all
      else
        associated_restaurant = user.first_associated_restaurant
        scope.where(id: associated_restaurant.id)
      end
    end
  end
end
