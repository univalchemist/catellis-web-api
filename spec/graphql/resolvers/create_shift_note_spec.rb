require 'rails_helper'

RSpec.describe Resolvers::CreateShiftNote, type: :feature do
  def service_instance
    described_class.new
  end

  it "creates a new shift note" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)

    expected_note = "Hello."

    args = {
      shift_start_at: (Time.zone.now).iso8601,
      note: expected_note
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to be_a(ShiftNote)
    expect(result).to be_persisted
    expect(result.note).to eq expected_note
    expect(result.author).to eq user
    expect(result.shift_start_at).to be_within(5.seconds).of(Time.zone.now)
  end
end
