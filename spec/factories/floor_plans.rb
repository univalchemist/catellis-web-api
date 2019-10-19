FactoryBot.define do
  factory :floor_plan do
    transient do
      number { FloorPlan.count + 1 }
    end

    restaurant { create(:restaurant) }
    name { "Floor Plan #{number}" }
  end
end
