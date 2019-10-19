FactoryBot.define do
  factory :reservation_plan do
    transient do
      number { ReservationPlan.count + 1 }
    end

    restaurant { create(:restaurant) }
    repeat { :annually }
    active_weekday_0 { true }
    active_weekday_1 { true }
    active_weekday_2 { true }
    active_weekday_3 { true }
    active_weekday_4 { true }
    active_weekday_5 { true }
    active_weekday_6 { true }
    effective_time_start_at '10:00'
    effective_time_end_at '23:00'
    cust_reservable_start_at '11:30'
    cust_reservable_end_at '21:30'

    name { "RSVP Plan #{number}" }
  end
end
