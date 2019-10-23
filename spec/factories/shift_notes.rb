FactoryBot.define do
  factory :shift_note do
    restaurant { create(:restaurant) }
    author { create(:user, :restaurant_employee, restaurant: restaurant) }

    shift_start_at { Time.zone.now - 2.hours }
    note { '' }

    trait :random_note do
      note { Faker::Hipster.paragraph(3) }
    end
  end
end
