# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

catellis_restaurant = Restaurant.create!(
  name: "Catelli's",
  timezone_name: 'America/Los_Angeles'
)

catellis_owner = User.create!(
  name: "Catelli's Owner",
  email: "owner@catellis.com",
  password: '12345678'
)

catellis_owner.add_role(:restaurant_owner, catellis_restaurant)
