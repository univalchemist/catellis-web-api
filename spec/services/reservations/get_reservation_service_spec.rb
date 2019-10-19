require 'rails_helper'

RSpec.describe Reservations::GetReservationService, type: :feature do
  def service_instance
    described_class.new
  end

  describe "silos by restaurant" do
    before(:each) do
      @rest1 = create(:restaurant)
      @rest2 = create(:restaurant)

      @rest1_rsvp = create(
        :reservation,
        restaurant: @rest1
      )
      @rest2_rsvp = create(
        :reservation,
        restaurant: @rest2
      )
    end

    def perform_test(restaurant:, id:, expect_success: true)
      rest_owner = create(
        :user,
        :restaurant_owner,
        restaurant: restaurant
      )
      results = service_instance.perform(
        args: {
          id: id
        },
        ctx: {
          current_user: rest_owner
        }
      )

      if expect_success
        expect(results.reservation).to be_persisted
      else
        expect(results.success).to be false
        expect(results.error).to be_a_kind_of(ActiveRecord::RecordNotFound)
      end
    end

    it "find Restaurant 1 Reservation for Restaurant 1 employee" do
      perform_test(
        restaurant: @rest1,
        id: @rest1_rsvp.id
      )
    end

    it "find Restaurant 2 Reservation for Restaurant 2 employee" do
      perform_test(
        restaurant: @rest2,
        id: @rest2_rsvp.id
      )
    end

    it "cannot find Restaurant 1 Reservation for Restaurant 2 employee" do
      perform_test(
        restaurant: @rest2,
        id: @rest1_rsvp.id,
        expect_success: false
      )
    end

    it "cannot find Restaurant 2 Reservation for Restaurant 1 employee" do
      perform_test(
        restaurant: @rest1,
        id: @rest2_rsvp.id,
        expect_success: false
      )
    end
  end
end
