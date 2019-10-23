require 'rails_helper'
require 'sample_data/populator'

RSpec.describe SampleData::Populator, type: :feature do
  def service_instance
    described_class.new
  end

  describe "builds for a restaurant" do
    # This is a pretty weak group of examples. But really this spec exists
    # primarily as a means to more quickly iterate on sample data routines.

    before(:each) do
      service_instance.call(restaurant_count: 1)
    end

    def verify_reservation_plan(plan_criteria:, plan_schedule_criteria:)
      reservation_schedule = ReservationPlanSchedule.find_by(plan_schedule_criteria)
      expect(reservation_schedule).to be_persisted
      reservation_plan_from_schedule = reservation_schedule.reservation_plan
      reservation_plan_from_criteria = ReservationPlan.find_by(plan_criteria)
      expect(reservation_plan_from_schedule).to eq reservation_plan_from_criteria
    end

    it "creates a restaurant" do
      expect(Restaurant.count).to eq 1
    end

    xit "creates reservation plans" do
      # FUTURE: this isn't completely fleshed out because it was becoming
      # quite burdensome just to verify the sample data.

      # Summer weekday
      verify_reservation_plan(
        plan_criteria: {
          name: "Summer Weekday Lunch"
        },
        plan_schedule_criteria: {
          repeat: :annually,
          effective_date_start_at: DateTime.new(2000, 4, 1).beginning_of_day,
          effective_date_end_at: DateTime.new(2000, 9, 30).end_of_day,
        }
      )
      verify_reservation_plan(
        plan_criteria: {
          name: "Summer Weekday Dinner"
        },
        plan_schedule_criteria: {
          repeat: :annually,
          effective_date_start_at: DateTime.new(2000, 4, 1).beginning_of_day,
          effective_date_end_at: DateTime.new(2000, 9, 30).end_of_day,
        }
      )

      # Summer weekend

      # Winter weekday

      # Winter weekend

      # Valentine's day
      verify_reservation_plan(
        plan_criteria: {
          name: "Valentine's Day",
        },
        plan_schedule_criteria: {
          repeat: :annually,
          effective_date_start_at: DateTime.new(2000, 02, 14).beginning_of_day,
          effective_date_end_at: DateTime.new(2000, 02, 14).end_of_day,
        }
      )
    end
  end
end
