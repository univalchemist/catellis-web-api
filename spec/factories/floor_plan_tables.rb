FactoryBot.define do
  factory :floor_plan_table do
    transient do
      restaurant { create(:restaurant) }
    end

    floor_plan { create(:floor_plan, restaurant: restaurant) }
    x { 0 }
    y { 0 }
    table_number { "1" }
    table_size { 4 }
    table_type { :indoor }
    table_shape { :rectangle }
    min_covers { 2 }
    max_covers { 4 }
  end
end
