require 'rails_helper'

RSpec.describe Resolvers::EditShiftNote, type: :feature do
  def service_instance
    described_class.new
  end

  it "updates an existing shift note" do
    shift_note = create(:shift_note)
    user = create(:user, :restaurant_employee, restaurant: shift_note.restaurant)

    expected_note = "Okay."

    args = {
      id: shift_note.id,
      note: expected_note
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result.note).to eq expected_note
  end
end
