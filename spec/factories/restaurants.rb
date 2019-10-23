FactoryBot.define do
  factory :restaurant do
    transient do
      number { Restaurant.count + 1 }
    end

    name { "Restaurant #{number}"}
    timezone_name { 'America/New_York' }

    trait :random_restaurant do
      transient do
        restaurant_name { "#{Faker::Food.spice}" }
      end

      name { restaurant_name }
    end
  end
end
