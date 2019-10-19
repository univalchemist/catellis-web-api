require 'rails_helper'

RSpec.describe User, type: :model do
  describe "supports soft-delete" do
    it "is hidden from default scope after destroy" do
      user = create(:user)

      user.destroy

      expect {
        User.find(user.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "is available from with_deleted scope after destroy" do
      user = create(:user)

      user.destroy

      found_user = User.with_deleted.find(user.id)

      expect(found_user).to eq user
    end
  end

  describe "roles" do
    it "allows a user to have a scoped restaurant_owner role" do
      restaurant = create(:restaurant)
      owner = create(
        :user,
        :restaurant_owner,
        restaurant: restaurant
      )

      expect(owner.has_role?(:restaurant_owner)).to be false
      expect(owner.has_role?(:restaurant_owner, restaurant)).to be true
    end

    it "finds associated restaurant" do
      restaurant = create(:restaurant)
      owner = create(
        :user,
        :restaurant_owner,
        restaurant: restaurant
      )

      expect(owner.first_associated_restaurant).to eq restaurant
    end
  end
end
