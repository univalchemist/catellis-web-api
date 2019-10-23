require 'rails_helper'

RSpec.describe Resolvers::GetCurrentShiftNote, type: :feature do
  def service_instance
    described_class.new
  end

  it "retrieves nothing when there are no shift notes" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)

    args = {
      shift_start_at: Time.zone.now.beginning_of_day.iso8601,
      shift_end_at: Time.zone.now.end_of_day.iso8601
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to be_nil
  end

  it "retrieves nothing when shift note is too far in the past" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)
    shift_note = create(
      :shift_note,
      restaurant: restaurant,
      shift_start_at: Time.zone.now.beginning_of_day - 5.hours
    )

    args = {
      shift_start_at: Time.zone.now.beginning_of_day.iso8601,
      shift_end_at: Time.zone.now.end_of_day.iso8601
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to be_nil
  end

  it "retrieves nothing when shift note is too far in the future" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)
    shift_note = create(
      :shift_note,
      restaurant: restaurant,
      shift_start_at: Time.zone.now.beginning_of_day + 2.days
    )

    args = {
      shift_start_at: Time.zone.now.beginning_of_day.iso8601,
      shift_end_at: Time.zone.now.end_of_day.iso8601
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to be_nil
  end

  it "retrieves shift note when its within time range" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)
    shift_note = create(
      :shift_note,
      restaurant: restaurant,
      shift_start_at: Time.zone.now.beginning_of_day + 5.hours
    )

    args = {
      shift_start_at: Time.zone.now.beginning_of_day.iso8601,
      shift_end_at: Time.zone.now.end_of_day.iso8601
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to be_a(ShiftNote)
    expect(result).to be_persisted
  end
end
