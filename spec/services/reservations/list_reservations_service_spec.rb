require 'rails_helper'

RSpec.describe Reservations::ListReservationsService, type: :feature do
  def service_instance
    described_class.new
  end

  describe "silos by restaurant" do
    before(:each) do
      @rest1 = create(:restaurant)
      @rest2 = create(:restaurant)

      @rest1_reservations = create_list(
        :reservation,
        3,
        restaurant: @rest1
      )

      @rest2_reservations = create_list(
        :reservation,
        2,
        restaurant: @rest2
      )
    end

    def perform_test(restaurant:, count:)
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

      expect(results.reservations.count).to eq count
    end

    it "returns Restaurant 1's reservations for Restaurant 1 employee" do
      perform_test(
        restaurant: @rest1,
        count: @rest1_reservations.count
      )
    end

    it "returns Restaurant 2's reservations for Restaurant 2 employee" do
      perform_test(
        restaurant: @rest2,
        count: @rest2_reservations.count
      )
    end
  end

  def perform_test(args, expected_results, user: @user)
    result = service_instance.perform(
      args: args,
      ctx: {
        current_user: user
      }
    )

    expect(result.reservations).to match expected_results
  end

  describe "searches by customer name" do
    before(:each) do
      @restaurant = create(:restaurant)
      @user = create(
        :user,
        :restaurant_employee,
        restaurant: @restaurant
      )
      @customer_1 = create(
        :customer,
        name: 'Eric Staal'
      )
      @customer_2 = create(
        :customer,
        name: 'Jordan Staal'
      )
      @cust_1_rsvp = create(
        :reservation,
        restaurant: @restaurant,
        customer: @customer_1
      )
      @cust_2_rsvp = create(
        :reservation,
        restaurant: @restaurant,
        customer: @customer_2
      )
    end

    it "finds one reservation for 'Eric'" do
      perform_test(
        {search_text: 'Eric'},
        [@cust_1_rsvp]
      )
    end

    it "finds one reservation for 'Jordan'" do
      perform_test(
        {search_text: 'Jordan'},
        [@cust_2_rsvp]
      )
    end

    it "finds two reservations for 'Staal'" do
      perform_test(
        {search_text: 'Staal'},
        [@cust_1_rsvp, @cust_2_rsvp]
      )
    end
  end

  describe "searches by reservation category" do
    before(:each) do
      @restaurant = create(:restaurant)
      @user = create(
        :user,
        :restaurant_employee,
        restaurant: @restaurant
      )
      @seated_reservations = [
        create(
          :reservation,
          restaurant: @restaurant,
          reservation_status: :seated
        ),
        create(
          :reservation,
          restaurant: @restaurant,
          reservation_status: :seated
        ),
      ]
      @upcoming_reservations = [
        create(
          :reservation,
          restaurant: @restaurant,
          reservation_status: :confirmed
        ),
        create(
          :reservation,
          restaurant: @restaurant,
          reservation_status: :not_confirmed
        ),
        create(
          :reservation,
          restaurant: @restaurant,
          reservation_status: :no_answer
        ),
        create(
          :reservation,
          restaurant: @restaurant,
          reservation_status: :wrong_number
        ),
        create(
          :reservation,
          restaurant: @restaurant,
          reservation_status: :left_message
        ),
      ]
      @waitlist_reservations = [
        create(
          :reservation,
          restaurant: @restaurant,
          reservation_status: :waitlist
        ),
        create(
          :reservation,
          restaurant: @restaurant,
          reservation_status: :waitlist
        ),
      ]
      @completed_reservations = [
        create(
          :reservation,
          restaurant: @restaurant,
          reservation_status: :complete
        ),
        create(
          :reservation,
          restaurant: @restaurant,
          reservation_status: :complete
        ),
      ]

      # Add canceled reservations; these currently aren't included in any
      # categories and therefore should not show up in any of the results.
      create(
        :reservation,
        restaurant: @restaurant,
        reservation_status: :canceled_guest
      )
      create(
        :reservation,
        restaurant: @restaurant,
        reservation_status: :canceled_restaurant
      )
    end

    it "finds the 'seated' reservations" do
      perform_test(
        {category: [:seated]},
        @seated_reservations
      )
    end

    it "finds the 'upcoming' reservations" do
      perform_test(
        {category: [:upcoming]},
        @upcoming_reservations
      )
    end

    it "finds the 'waitlist' reservations" do
      perform_test(
        {category: [:waitlist]},
        @waitlist_reservations
      )
    end

    it "finds the 'completed' reservations" do
      perform_test(
        {category: [:complete]},
        @completed_reservations
      )
    end

    it "finds the 'seated,upcoming,waitlist' reservations" do
      perform_test(
        {category: [:seated,:upcoming,:waitlist,:complete]},
        [
          @seated_reservations,
          @upcoming_reservations,
          @waitlist_reservations,
          @completed_reservations
        ].flatten
      )
    end
  end

  describe "search reservations by datetime range" do
    before(:each) do
      @restaurant = create(:restaurant)
      @user = create(
        :user,
        :restaurant_employee,
        restaurant: @restaurant
      )

      @beginning_of_day = Time.zone.now.beginning_of_day
      @end_of_day = @beginning_of_day + 24.hours

      @rsvp_minus2 = create(
        :reservation,
        restaurant: @restaurant,
        scheduled_start_at: @beginning_of_day - 2.hours
      )
      @rsvp_plus18 = create(
        :reservation,
        restaurant: @restaurant,
        scheduled_start_at: @beginning_of_day + 18.hours
      )
      @rsvp_plus20 = create(
        :reservation,
        restaurant: @restaurant,
        scheduled_start_at: @beginning_of_day + 20.hours
      )
      @rsvp_plus30 = create(
        :reservation,
        restaurant: @restaurant,
        scheduled_start_at: @beginning_of_day + 30.hours
      )
      @rsvp_plus36 = create(
        :reservation,
        restaurant: @restaurant,
        scheduled_start_at: @beginning_of_day + 36.hours
      )
    end

    it "assumes a default range of 24 hours" do
      perform_test(
        {scheduled_range_start_at: @beginning_of_day.iso8601},
        [@rsvp_plus18, @rsvp_plus20]
      )
    end

    it "finds reservation within a given range" do
      perform_test(
        {
          scheduled_range_start_at: @beginning_of_day.iso8601,
          scheduled_range_end_at: (@beginning_of_day + 48.hours).iso8601
        },
        [@rsvp_plus18, @rsvp_plus20, @rsvp_plus30, @rsvp_plus36]
      )
    end

    describe "finds reservations that are overlapping with the provided datetime range" do
      it "overlaps beginning of datetime range" do
        rsvp = create(
          :reservation,
          restaurant: @restaurant,
          scheduled_start_at: @beginning_of_day - 1.hours
        )

        perform_test(
          {
            scheduled_range_start_at: @beginning_of_day.iso8601,
            scheduled_range_end_at: @end_of_day.iso8601
          },
          [rsvp, @rsvp_plus18, @rsvp_plus20]
        )
      end

      it "overlaps ending of datetime range" do
        rsvp = create(
          :reservation,
          restaurant: @restaurant,
          scheduled_start_at: @end_of_day - 1.hours
        )

        perform_test(
          {
            scheduled_range_start_at: @beginning_of_day.iso8601,
            scheduled_range_end_at: @end_of_day.iso8601
          },
          [@rsvp_plus18, @rsvp_plus20, rsvp]
        )
      end
    end
  end

  describe "searches reservations by table" do
    it "finds by table id" do
      @restaurant = create(:restaurant)
      @user = create(
        :user,
        :restaurant_employee,
        restaurant: @restaurant
      )
      @floor_plan_table = create(
        :floor_plan_table,
        restaurant: @restaurant
      )

      @now = Time.zone.now
      @beginning_of_day = @now.beginning_of_day
      @end_of_day = @now.end_of_day

      @rsvp_table = create(
        :reservation,
        restaurant: @restaurant,
        scheduled_start_at: @beginning_of_day + 18.hours,
        floor_plan_table: @floor_plan_table
      )
      @rsvp_no_table = create(
        :reservation,
        restaurant: @restaurant,
        scheduled_start_at: @beginning_of_day + 18.hours
      )

      perform_test(
        {
          scheduled_range_start_at: @beginning_of_day.iso8601,
          scheduled_range_end_at: @end_of_day.iso8601,
          floor_plan_table_id: @floor_plan_table.id
        },
        [@rsvp_table]
      )
    end
  end
end
