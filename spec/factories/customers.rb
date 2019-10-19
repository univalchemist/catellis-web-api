FactoryBot.define do
  factory :customer do
    transient do
      number { Customer.count + 1 }
    end

    restaurant { create(:restaurant) }
    name { "Customer #{number}"}
    email { nil }
    phone_number { "844555" + number.to_s.rjust(4, '0') }

    trait :random_customer do
      transient do
        user_name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
      end

      name { user_name }
    end
  end
end
