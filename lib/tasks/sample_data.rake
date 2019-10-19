require 'sample_data/populator'

namespace :db do
  desc 'Drop, create, migrate, seed and populate sample data'
  # Task arguments are collected here so that they are available to the child
  # task populate_sample_data.
  task prepare: [:reset, :populate] do
    puts 'Ready to go!'
  end

  task dev_test_reset: [:drop, :create, :migrate, 'test:prepare'] do
    puts "Ready to continue development and testing!"
  end

  desc 'Populates with dev seed data'
  task populate: [:seed, :environment] do
    SampleData::Populator.new.call(restaurant_count: 2)
  end

  desc "Populates default restaurant (Catelli's) with sample data"
  task populate_catellis: [:populate] do
    catellis = Restaurant.find 1

    SampleData::RestaurantBuilder.new.call(catellis)
  end
end
