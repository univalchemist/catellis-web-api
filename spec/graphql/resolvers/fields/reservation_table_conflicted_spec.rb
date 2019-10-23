require 'rails_helper'

RSpec.describe Resolvers::Fields::ReservationTableConflicted, type: :feature do
  def service_instance
    described_class.new
  end

  before(:each) do
    @restaurant = create(:restaurant)
    @user = create(:user, :restaurant_employee, restaurant: @restaurant)
    @floor_plan = create(:floor_plan, restaurant: @restaurant)
    @floor_plan_table_1 = create(:floor_plan_table, floor_plan: @floor_plan, table_number: '1')
    @floor_plan_table_2 = create(:floor_plan_table, floor_plan: @floor_plan, table_number: '2')
  end

  def perform_test(
    rsvp_1_start:,
    rsvp_1_end: rsvp_1_start + 90.minutes,
    rsvp_1_status: :seated,
    rsvp_1_table:,
    rsvp_2_start:,
    rsvp_2_end: rsvp_2_start + 90.minutes,
    rsvp_2_status: :seated,
    rsvp_2_table:,
    expected_result:
  )
    reservation_1 = create(
      :reservation,
      restaurant: @restaurant,
      floor_plan_table: rsvp_1_table,
      scheduled_start_at: rsvp_1_start,
      scheduled_end_at: rsvp_1_end,
      reservation_status: rsvp_1_status,
    )
    reservation_2 = create(
      :reservation,
      restaurant: @restaurant,
      floor_plan_table: rsvp_2_table,
      scheduled_start_at: rsvp_2_start,
      scheduled_end_at: rsvp_2_end,
      reservation_status: rsvp_2_status,
    )

    result = service_instance.call(reservation_1, {}, {current_user: @user})
    expect(result).to be expected_result
    result = service_instance.call(reservation_2, {}, {current_user: @user})
    expect(result).to be expected_result
  end

  it "finds no conflicts when the reservation has no floor plan table" do
    reservation = create(
      :reservation,
      restaurant: @restaurant
    )

    result = service_instance.call(reservation, {}, {current_user: @user})
    expect(result).to be false
  end

  it "finds no conflicts when there is only a single reservation for the table" do
    reservation = create(
      :reservation,
      restaurant: @restaurant,
      floor_plan_table: @floor_plan_table_1
    )

    result = service_instance.call(reservation, {}, {current_user: @user})
    expect(result).to be false
  end

  describe "finds no conflicts between reservations assigned to different tables" do
    it "finds no conflict when reseservations have identical datetime ranges" do
      scheduled_start_at = Time.zone.now
      perform_test(
        rsvp_1_start: scheduled_start_at,
        rsvp_1_table: @floor_plan_table_1,
        rsvp_2_start: scheduled_start_at,
        rsvp_2_table: @floor_plan_table_2,
        expected_result: false,
      )
    end

    it "finds no conflict when reseservations have identical datetime ranges, and one reservation has no table assignment" do
      scheduled_start_at = Time.zone.now
      perform_test(
        rsvp_1_start: scheduled_start_at,
        rsvp_1_table: @floor_plan_table_1,
        rsvp_2_start: scheduled_start_at,
        rsvp_2_table: nil,
        expected_result: false,
      )
    end
  end

  describe "finds conflicts when two reservation are assigned to the same table" do
    it "finds a conflict when reseservations have identical datetime ranges" do
      scheduled_start_at = Time.zone.now
      perform_test(
        rsvp_1_start: scheduled_start_at,
        rsvp_1_table: @floor_plan_table_1,
        rsvp_2_start: scheduled_start_at,
        rsvp_2_table: @floor_plan_table_1,
        expected_result: true,
      )
    end

    it "finds a conflict when reseservations partially overlap" do
      scheduled_start_at = Time.zone.now
      perform_test(
        rsvp_1_start: scheduled_start_at,
        rsvp_1_table: @floor_plan_table_1,
        rsvp_2_start: scheduled_start_at - 30.minutes,
        rsvp_2_table: @floor_plan_table_1,
        expected_result: true,
      )
    end
  end

  describe "compares based on reservation status" do
    def perform_status_test(rsvp_1_status:, rsvp_2_status:, expected_result:)
      scheduled_start_at = Time.zone.now
      perform_test(
        rsvp_1_start: scheduled_start_at,
        rsvp_1_table: @floor_plan_table_1,
        rsvp_1_status: rsvp_1_status,
        rsvp_2_start: scheduled_start_at,
        rsvp_2_table: @floor_plan_table_1,
        rsvp_2_status: rsvp_2_status,
        expected_result: expected_result
      )
    end

    it "finds no conflict when reservation are seated/complete" do
      perform_status_test(
        rsvp_1_status: :seated,
        rsvp_2_status: :complete,
        expected_result: false,
      )
    end

    it "finds conflict when reservation are seated/waitlist" do
      perform_status_test(
        rsvp_1_status: :seated,
        rsvp_2_status: :waitlist,
        expected_result: true,
      )
    end

    it "finds conflict when reservation are not_confirmed/canceled_guest" do
      perform_status_test(
        rsvp_1_status: :not_confirmed,
        rsvp_2_status: :canceled_guest,
        expected_result: false,
      )
    end
  end
end
