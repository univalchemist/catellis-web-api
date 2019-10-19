require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe "supports soft-delete" do
    it "is hidden from default scope after destroy" do
      restaurant = create(:restaurant)

      restaurant.destroy

      expect {
        Restaurant.find(restaurant.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "is available from with_deleted scope after destroy" do
      restaurant = create(:restaurant)

      restaurant.destroy

      found = Restaurant.with_deleted.find(restaurant.id)

      expect(found).to eq restaurant
    end
  end
end
