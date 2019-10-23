FactoryBot.define do
  factory :reservation do
    restaurant { create(:restaurant) }
    customer { create(:customer, restaurant: restaurant) }
    scheduled_start_at { Time.zone.now.beginning_of_day + 12.hours }
    scheduled_end_at { scheduled_start_at + 90.minutes }
    party_size 2
    party_notes { nil }
    reservation_status { :not_confirmed }
  end
end
