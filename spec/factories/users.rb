role_to_abbr_map = {
  restaurant_owner: 'o',
  restaurant_employee: 'e'
}

def restaurant_scoped_role_counter(role, restaurant)
  Role
    .where(name: roles.first[:role], resource: restaurant)
    .count + 1
end

FactoryBot.define do
  factory :user do
    transient do
      number { User.count + 1 }
      roles { [] }
    end

    email { "u#{number}@mailinator.com" }
    password { 'changeme' }
    name { "User #{number}"}

    after(:build) do |user, evaluator|
      if evaluator.roles
        # TODO: This is probably wrong, as it's creating a new Role record
        # to associate with a yet-to-be-persisted User record (as we're still
        # in the :build callback).
        evaluator.roles.each do |role_info|
          if role_info.is_a?(Hash)
            user.add_role(role_info[:role], role_info[:entity])
          elsif role_info.is_a?(Symbol)
            user.add_role(role_info)
          end
        end
      end
    end

    trait :random_user do
      transient do
        user_name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
      end

      email { user_name.downcase.gsub(/\s/,'.') + '@mailinator.com' }
      name { user_name }
    end

    trait :restaurant_owner do
      transient do
        restaurant { create(:restaurant) }
        roles {[
          {role: :restaurant_owner, entity: restaurant }
        ]}
      end

      name { "Restaurant Owner #{restaurant_scoped_role_counter(roles.first[:role], restaurant)}" }
    end

    trait :restaurant_employee do
      transient do
        restaurant { create(:restaurant) }
        roles {[
          {role: :restaurant_employee, entity: restaurant }
        ]}
      end

      name { "Restaurant Employee #{restaurant_scoped_role_counter(roles.first[:role], restaurant)}" }
    end

    trait :roleaware_ordinal_email do
      transient do
        restaurant { create(:restaurant) }
      end

      # Create short, descriptive email addresses like r1-o1 (restaurant 1, owner 1)
      email { "r#{restaurant.id}-#{role_to_abbr_map[roles.first[:role]]}#{restaurant_scoped_role_counter(roles.first[:role], restaurant)}@mailinator.com" }
    end
  end
end
