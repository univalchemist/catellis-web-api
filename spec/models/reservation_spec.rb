require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe "supports soft-delete" do
    before(:each) do
      @reservation = create(:reservation)
    end

    it "is hidden from default scope after destroy" do
      @reservation.destroy

      expect {
        Reservation.find(@reservation.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "is available from with_deleted scope after destroy" do
      @reservation.destroy

      found = Reservation.with_deleted.find(@reservation.id)

      expect(found).to eq @reservation
    end
  end

  describe "local_scheduled_start_at" do
    # TODO: These are odd tests. They effectively just rewrite the
    # implementation, and then verify that the Reservation model does the
    # same thing. For the moment these will suffice but they probably should be
    # revisited in the future.
    it "converts to local time" do
      timezone_name = 'America/New_York'
      timezone = Timezone[timezone_name]
      @restaurant = create(
        :restaurant,
        timezone_name: timezone_name
      )
      @reservation = create(:reservation, restaurant: @restaurant)
      expected_local_scheduled_start_at = timezone.utc_to_local(@reservation.scheduled_start_at)

      local_scheduled_start_at = @reservation.local_scheduled_start_at

      expect(local_scheduled_start_at).to eq expected_local_scheduled_start_at
    end
  end
end
