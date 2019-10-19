require 'rails_helper'

RSpec.describe Customers::ListCustomersService, type: :feature do
  def service_instance
    described_class.new
  end

  describe "silos by restaurant" do
    before(:each) do
      @rest1 = create(:restaurant)
      @rest2 = create(:restaurant)

      @rest1_customers = create_list(
        :customer,
        3,
        restaurant: @rest1
      )

      @rest2_customers = create_list(
        :customer,
        2,
        restaurant: @rest2
      )
    end

    def perform_test(restaurant:, customers_count:)
      rest_owner = create(
        :user,
        :restaurant_owner,
        restaurant: restaurant
      )
      results = service_instance.perform(
        args: {},
        ctx: {
          current_user: rest_owner
        }
      )

      expect(results.customers.count).to eq customers_count
    end

    it "returns Restaurant 1's customers for Restaurant 1 employee" do
      perform_test(
        restaurant: @rest1,
        customers_count: @rest1_customers.count
      )
    end

    it "returns Restaurant 2's customers for Restaurant 2 employee" do
      perform_test(
        restaurant: @rest2,
        customers_count: @rest2_customers.count
      )
    end
  end
end
