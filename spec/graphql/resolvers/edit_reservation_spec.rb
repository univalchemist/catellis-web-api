require 'rails_helper'

RSpec.describe Resolvers::EditReservation, type: :feature do
  def service_instance
    described_class.new
  end

  it "updates an existing reservation (no additional triggers)" do
    reservation = create(:reservation)
    user = create(:user, :restaurant_employee, restaurant: reservation.restaurant)

    expected_party_size = 4
    expected_scheduled_start_at = Time.zone.now + 3.days
    expected_scheduled_end_at = expected_scheduled_start_at + 90.minutes
    expected_party_notes = "Oh yay. It's someone's birthday."
    expected_reservation_status = :confirmed

    args = {
      input: {
        id: reservation.id,
        party_size: expected_party_size,
        scheduled_start_at: (expected_scheduled_start_at).iso8601,
        party_notes: expected_party_notes,
        reservation_status: expected_reservation_status.to_s
      }
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result.party_size).to eq expected_party_size
    expect(result.scheduled_start_at).to be_within(5.seconds).of(expected_scheduled_start_at)
    expect(result.scheduled_end_at).to be_within(5.seconds).of(expected_scheduled_end_at)
    expect(result.party_notes).to eq expected_party_notes
    expect(result.reservation_status).to eq expected_reservation_status.to_s
  end

  describe "updates floor plan table association" do
    it "assigns a reservation to a floor plan table" do
      reservation = create(:reservation)
      user = create(:user, :restaurant_employee, restaurant: reservation.restaurant)
      floor_plan = create(
        :floor_plan,
        restaurant: reservation.restaurant,
        floor_plan_tables: [
          build(
            :floor_plan_table,
            x: 10,
            y: 10
          )
        ]
      )
      table = floor_plan.floor_plan_tables.first

      args = {
        input: {
          id: reservation.id,
          floor_plan_table_id: table.id
        }
      }
      ctx = {
        current_user: user
      }

      result = service_instance.call({}, args, ctx)

      expect(result.floor_plan_table).to eq table
    end
    it "assigns a reservation to a floor plan table" do
      restaurant = create(:restaurant)
      floor_plan = create(
        :floor_plan,
        restaurant: restaurant,
        floor_plan_tables: [
          build(
            :floor_plan_table,
            x: 10,
            y: 10
          )
        ]
      )
      table = floor_plan.floor_plan_tables.first
      user = create(:user, :restaurant_employee, restaurant: restaurant)
      reservation = create(
        :reservation,
        restaurant: restaurant,
        floor_plan_table: table
      )

      args = {
        input: {
          id: reservation.id,
          floor_plan_table_id: nil
        }
      }
      ctx = {
        current_user: user
      }

      result = service_instance.call({}, args, ctx)

      expect(result.floor_plan_table).to be nil
    end
  end

  describe "waitlist to seated notification" do
    it "sends a notification" do
      reservation = create(
        :reservation,
        reservation_status: :waitlist
      )
      user = create(:user, :restaurant_employee, restaurant: reservation.restaurant)

      expected_reservation_status = :seated
      args = {
        input: {
          id: reservation.id,
          reservation_status: expected_reservation_status
        }
      }
      ctx = {
        current_user: user
      }

      expect_any_instance_of(Notifications::WaitlistToSeatedReservationNotification)
      .to(
        receive(:perform)
        .with(reservation: kind_of(Reservation))
        .and_return(nil)
      )

      result = service_instance.call({}, args, ctx)

      expect(result.reservation_status).to eq expected_reservation_status.to_s
    end

    it "survives and updates reservation if notification failed" do
      reservation = create(
        :reservation,
        reservation_status: :waitlist
      )
      user = create(:user, :restaurant_employee, restaurant: reservation.restaurant)

      expected_reservation_status = :seated
      args = {
        input: {
          id: reservation.id,
          reservation_status: expected_reservation_status
        }
      }
      ctx = {
        current_user: user
      }

      expect_any_instance_of(Notifications::WaitlistToSeatedReservationNotification)
      .to(
        receive(:perform)
        .with(reservation: kind_of(Reservation))
        .and_raise(Twilio::REST::RestError.new('error', 'error', 400))
      )

      result = service_instance.call({}, args, ctx)

      expect(result.reservation_status).to eq expected_reservation_status.to_s
    end
  end

  describe "cancelations" do
    it "sends a notification when the reservation is canceled (at request of customer)" do
      reservation = create(:reservation)
      user = create(:user, :restaurant_employee, restaurant: reservation.restaurant)

      expected_reservation_status = :canceled_guest
      args = {
        input: {
          id: reservation.id,
          reservation_status: expected_reservation_status
        }
      }
      ctx = {
        current_user: user
      }

      expect_any_instance_of(Notifications::CanceledReservationNotification)
      .to(
        receive(:perform)
        .with(reservation: kind_of(Reservation))
        .and_return(nil)
      )

      result = service_instance.call({}, args, ctx)

      expect(result.reservation_status).to eq expected_reservation_status.to_s
    end

    it "sends a notification when the reservation is canceled (at request of restaurant)" do
      reservation = create(:reservation)
      user = create(:user, :restaurant_employee, restaurant: reservation.restaurant)

      expected_reservation_status = :canceled_restaurant
      args = {
        input: {
          id: reservation.id,
          reservation_status: expected_reservation_status
        }
      }
      ctx = {
        current_user: user
      }

      expect_any_instance_of(Notifications::CanceledReservationNotification)
      .to(
        receive(:perform)
        .with(reservation: kind_of(Reservation))
        .and_return(nil)
      )

      result = service_instance.call({}, args, ctx)

      expect(result.reservation_status).to eq expected_reservation_status.to_s
    end

    it "survives a notification failure" do
      reservation = create(:reservation)
      user = create(:user, :restaurant_employee, restaurant: reservation.restaurant)

      expected_reservation_status = :canceled_guest
      args = {
        input: {
          id: reservation.id,
          reservation_status: expected_reservation_status
        }
      }
      ctx = {
        current_user: user
      }

      expect_any_instance_of(Notifications::CanceledReservationNotification)
      .to(
        receive(:perform)
        .with(reservation: kind_of(Reservation))
        .and_raise(Twilio::REST::RestError.new('error', 'error', 400))
      )

      result = service_instance.call({}, args, ctx)

      expect(result.reservation_status).to eq expected_reservation_status.to_s
    end
  end
end
