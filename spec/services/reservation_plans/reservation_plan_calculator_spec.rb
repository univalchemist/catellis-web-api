require 'rails_helper'

RSpec.describe ReservationPlans::ReservationPlanCalculator, type: :feature do
  def service_instance
    described_class.new
  end

  describe "specific day" do
    before(:each) do
      @restaurant = create(:restaurant)
      @user = create(:user, :restaurant_employee, restaurant: @restaurant)
    end

    def perform_test(search_start_at:, expected_results:)
      results = service_instance.perform(
        restaurant: @restaurant,
        search_start_at: search_start_at,
      )

      expect(results).to eq expected_results
    end

    describe "Valentine's day" do
      before(:each) do
        @reservation_plan = create(
          :reservation_plan,
          restaurant: @restaurant,
          effective_time_start_at: '10:00',
          effective_time_end_at: '23:00',
          cust_reservable_start_at: '11:30',
          cust_reservable_end_at: '21:30',
          repeat: :annually,
          effective_date_start_at: DateTime.new(2000, 02, 14).beginning_of_day,
          effective_date_end_at: DateTime.new(2000, 02, 14).end_of_day,
        )
      end

      it "finds for current year" do
        perform_test(
          search_start_at: DateTime.new(2018, 02, 14),
          expected_results: [@reservation_plan]
        )
      end

      it "finds for next year" do
        perform_test(
          search_start_at: DateTime.new(2019, 02, 14),
          expected_results: [@reservation_plan]
        )
      end

      describe "fails for other days" do
        it "fails for 2017-06-01" do
          perform_test(
            search_start_at: DateTime.new(2019, 06, 06),
            expected_results: []
          )
        end

        it "fails for 2017-02-13" do
          perform_test(
            search_start_at: DateTime.new(2019, 02, 13),
            expected_results: []
          )
        end

        it "fails for 2017-02-15" do
          perform_test(
            search_start_at: DateTime.new(2019, 02, 15),
            expected_results: []
          )
        end
      end
    end

    describe "Valentine's day override" do
      before(:each) do
        @reservation_plan_valentines = create(
          :reservation_plan,
          restaurant: @restaurant,
          effective_time_start_at: '10:00',
          effective_time_end_at: '23:00',
          cust_reservable_start_at: '11:30',
          cust_reservable_end_at: '21:30',
          priority: 200,
          repeat: :annually,
          effective_date_start_at: DateTime.new(2000, 02, 14).beginning_of_day,
          effective_date_end_at: DateTime.new(2000, 02, 14).end_of_day,
        )
        @reservation_plan_normal = create(
          :reservation_plan,
          restaurant: @restaurant,
          effective_time_start_at: '10:00',
          effective_time_end_at: '23:00',
          cust_reservable_start_at: '11:30',
          cust_reservable_end_at: '21:30',
          repeat: :annually,
          effective_date_start_at: DateTime.new(2000, 01, 1).beginning_of_day,
          effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
        )
      end

      it "finds valentine's plan for current year" do
        perform_test(
          search_start_at: DateTime.new(2018, 02, 14),
          expected_results: [@reservation_plan_valentines]
        )
      end

      it "finds valentine's plan for next year" do
        perform_test(
          search_start_at: DateTime.new(2019, 02, 14),
          expected_results: [@reservation_plan_valentines]
        )
      end
    end

    describe "Single day override" do
      before(:each) do
        @reservation_plan = create(
          :reservation_plan,
          restaurant: @restaurant,
          effective_time_start_at: '10:00',
          effective_time_end_at: '23:00',
          cust_reservable_start_at: '11:30',
          cust_reservable_end_at: '21:30',
          repeat: :none,
          effective_date_start_at: DateTime.new(2018, 02, 03).beginning_of_day,
          effective_date_end_at: DateTime.new(2018, 02, 03).end_of_day,
        )
      end

      it "finds for current year" do
        perform_test(
          search_start_at: DateTime.new(2018, 02, 03),
          expected_results: [@reservation_plan]
        )
      end

      describe "fails for other days" do
        it "fails for 2019-02-03" do
          perform_test(
            search_start_at: DateTime.new(2019, 02, 03),
            expected_results: []
          )
        end

        it "fails for 2017-02-02" do
          perform_test(
            search_start_at: DateTime.new(2018, 02, 02),
            expected_results: []
          )
        end

        it "fails for 2017-02-04" do
          perform_test(
            search_start_at: DateTime.new(2018, 02, 04),
            expected_results: []
          )
        end
      end
    end

    describe "Sunday - brunch (day of week test)" do
      before(:each) do
        @reservation_plan = create(
          :reservation_plan,
          restaurant: @restaurant,
          effective_time_start_at: '10:00',
          effective_time_end_at: '23:00',
          cust_reservable_start_at: '11:30',
          cust_reservable_end_at: '21:30',
          repeat: :annually,
          active_weekday_0: true,
          active_weekday_1: false,
          active_weekday_2: false,
          active_weekday_3: false,
          active_weekday_4: false,
          active_weekday_5: false,
          active_weekday_6: false,
          effective_date_start_at: DateTime.new(2000, 1, 1).beginning_of_day,
          effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
        )
      end

      it "finds for Sun 13 May 2018" do
        perform_test(
          search_start_at: DateTime.new(2018, 5, 13),
          expected_results: [@reservation_plan]
        )
      end

      it "fails for Sat 12 May 2018" do
        perform_test(
          search_start_at: DateTime.new(2018, 5, 12),
          expected_results: []
        )
      end

      it "fails for Mon 14 May 2018" do
        perform_test(
          search_start_at: DateTime.new(2018, 5, 14),
          expected_results: []
        )
      end
    end

    describe "All week - lunch, dinner" do
      before(:each) do
        @reservation_plan_lunch = create(
          :reservation_plan,
          restaurant: @restaurant,
          effective_time_start_at: '10:00',
          effective_time_end_at: '14:00',
          cust_reservable_start_at: '11:00',
          cust_reservable_end_at: '13:00',
          repeat: :annually,
          effective_date_start_at: DateTime.new(2000, 1, 1).beginning_of_day,
          effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
        )
        @reservation_plan_dinner = create(
          :reservation_plan,
          restaurant: @restaurant,
          effective_time_start_at: '15:00',
          effective_time_end_at: '23:00',
          cust_reservable_start_at: '17:00',
          cust_reservable_end_at: '12:00',
          repeat: :annually,
          effective_date_start_at: DateTime.new(2000, 1, 1).beginning_of_day,
          effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
        )
      end

      it "finds lunch and dinner for 1 Jun 2018" do
        perform_test(
          search_start_at: DateTime.new(2018, 6, 1),
          expected_results: [@reservation_plan_lunch, @reservation_plan_dinner]
        )
      end
    end

    describe "All week, all day, summer, winter" do
      before(:each) do
        @summer_start_at = DateTime.new(2000, 4, 1)
        @summer_end_at = DateTime.new(2000, 9, 30)

        @winter_start_at = DateTime.new(2000, 10, 1)
        @winter_end_at = DateTime.new(2001, 3, 30)

        # Summer, covered by a single range of 1 Apr - 30 Sep
        @reservation_plan_summer = create(
          :reservation_plan,
          restaurant: @restaurant,
          effective_time_start_at: '10:00',
          effective_time_end_at: '23:00',
          cust_reservable_start_at: '11:30',
          cust_reservable_end_at: '21:30',
          repeat: :annually,
          effective_date_start_at: @summer_start_at.beginning_of_day,
          effective_date_end_at: @summer_end_at.end_of_day,
        )

        # Winter, covered by (wrapping) range of 1 Oct - 30 Mar
        @reservation_plan_winter = create(
          :reservation_plan,
          restaurant: @restaurant,
          effective_time_start_at: '10:00',
          effective_time_end_at: '23:00',
          cust_reservable_start_at: '11:30',
          cust_reservable_end_at: '21:30',
          repeat: :annually,
          effective_date_start_at: @winter_start_at.beginning_of_day,
          effective_date_end_at: @winter_end_at.end_of_day,
        )
      end

      describe "finds summer plans" do
        it "for 1 Apr 2018" do
          perform_test(
            search_start_at: @summer_start_at,
            expected_results: [@reservation_plan_summer]
          )
        end

        it "for 1 Jun 2018" do
          perform_test(
            search_start_at: DateTime.new(2018, 6, 1),
            expected_results: [@reservation_plan_summer]
          )
        end

        it "for 1 Jun 2019" do
          perform_test(
            search_start_at: DateTime.new(2019, 6, 1),
            expected_results: [@reservation_plan_summer]
          )
        end

        it "for 30 Sep 2018" do
          perform_test(
            search_start_at: @summer_end_at,
            expected_results: [@reservation_plan_summer]
          )
        end
      end

      describe "finds winter plans" do
        it "for 1 Oct 2018" do
          perform_test(
            search_start_at: @winter_start_at,
            expected_results: [@reservation_plan_winter]
          )
        end

        it "for 1 Nov 2018" do
          perform_test(
            search_start_at: DateTime.new(2019, 11, 1),
            expected_results: [@reservation_plan_winter]
          )
        end

        it "for 31 Dec 2018" do
          perform_test(
            search_start_at: DateTime.new(2000, 12, 31),
            expected_results: [@reservation_plan_winter]
          )
        end

        it "for 1 Jan 2019" do
          perform_test(
            search_start_at: DateTime.new(2001, 1, 1),
            expected_results: [@reservation_plan_winter]
          )
        end

        it "for 3 Feb 2019" do
          perform_test(
            search_start_at: DateTime.new(2019, 2, 3),
            expected_results: [@reservation_plan_winter]
          )
        end

        it "for 30 Mar 2019" do
          perform_test(
            search_start_at: @winter_end_at,
            expected_results: [@reservation_plan_winter]
          )
        end
      end
    end

    describe "Weekday (Mo/Tu/We/Th) and Weekend (Fr/Sa/Su) - all day, all year" do
      before(:each) do
        @reservation_plan_weekday = create(
          :reservation_plan,
          restaurant: @restaurant,
          effective_time_start_at: '10:00',
          effective_time_end_at: '23:00',
          cust_reservable_start_at: '11:30',
          cust_reservable_end_at: '21:30',
          repeat: :annually,
          active_weekday_0: false,
          active_weekday_1: true,
          active_weekday_2: true,
          active_weekday_3: true,
          active_weekday_4: true,
          active_weekday_5: false,
          active_weekday_6: false,
          effective_date_start_at: DateTime.new(2000, 1, 1).beginning_of_day,
          effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
        )

        @reservation_plan_weekend = create(
          :reservation_plan,
          restaurant: @restaurant,
          effective_time_start_at: '10:00',
          effective_time_end_at: '23:00',
          cust_reservable_start_at: '11:30',
          cust_reservable_end_at: '21:30',
          repeat: :annually,
          active_weekday_0: true,
          active_weekday_1: false,
          active_weekday_2: false,
          active_weekday_3: false,
          active_weekday_4: false,
          active_weekday_5: true,
          active_weekday_6: true,
          effective_date_start_at: DateTime.new(2000, 1, 1).beginning_of_day,
          effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
        )
      end

      describe "finds weekday plans" do
        # Monday
        it "for 14 May 2018" do
          perform_test(
            search_start_at: DateTime.new(2018, 5, 14),
            expected_results: [@reservation_plan_weekday]
          )
        end

        # Tuesday
        it "for 25 Dec 2018" do
          perform_test(
            search_start_at: DateTime.new(2018, 12, 25),
            expected_results: [@reservation_plan_weekday]
          )
        end

        # Wednesday
        it "for 15 Aug 2018" do
          perform_test(
            search_start_at: DateTime.new(2018, 8, 15),
            expected_results: [@reservation_plan_weekday]
          )
        end

        # Thursday
        it "for 26 Jul 2018" do
          perform_test(
            search_start_at: DateTime.new(2018, 7, 26),
            expected_results: [@reservation_plan_weekday]
          )
        end
      end

      describe "finds weekend plans" do
        # Friday
        it "for 23 Nov 2018" do
          perform_test(
            search_start_at: DateTime.new(2018, 11, 23),
            expected_results: [@reservation_plan_weekend]
          )
        end

        # Saturday
        it "for 3 Feb 2018" do
          perform_test(
            search_start_at: DateTime.new(2018, 2, 3),
            expected_results: [@reservation_plan_weekend]
          )
        end

        # Sunday
        it "for 13 May 2018" do
          perform_test(
            search_start_at: DateTime.new(2018, 5, 13),
            expected_results: [@reservation_plan_weekend]
          )
        end
      end
    end
  end
end
