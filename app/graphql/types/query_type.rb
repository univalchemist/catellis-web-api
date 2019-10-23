Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  # Users/auth
  field :meUser, function: Resolvers::MeUser.new

  # Restaurant
  field :getCurrentRestaurant, function: Resolvers::GetCurrentRestaurant.new
  field :getMarketingRestaurant, function: Resolvers::GetMarketingRestaurant.new

  # Customers
  field :listCustomers, function: Resolvers::ListCustomers.new
  field :getCustomer, function: Resolvers::GetCustomer.new

  # Reservations
  field :getReservation, function: Resolvers::GetReservation.new
  field :listReservations, function: Resolvers::ListReservations.new

  # Shift notes
  field :getCurrentShiftNote, function: Resolvers::GetCurrentShiftNote.new

  # Floor plans
  field :getFloorPlan, function: Resolvers::GetFloorPlan.new
  field :listFloorPlans, function: Resolvers::ListFloorPlans.new

  # Floor plan tables
  field :listFloorPlanTables, function: Resolvers::ListFloorPlanTables.new
  field :getFloorPlanTable, function: Resolvers::GetFloorPlanTable.new

  # Reservation plans
  field :listDailyReservationPlans, function: Resolvers::ListDailyReservationPlans.new
  field :getReservationPlan, function: Resolvers::GetReservationPlan.new

  # Reservation times
  field :listAvailableReservationTimes, function: Resolvers::ListAvailableReservationTimes.new
end
