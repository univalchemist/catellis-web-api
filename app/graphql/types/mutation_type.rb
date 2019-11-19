Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  # Users/auth
  field :signInUser, function: Resolvers::SignInUser.new

  # Restaurants
  field :editRestaurant, function: Resolvers::EditRestaurant.new

  # Customers
  field :createCustomer, function: Resolvers::CreateCustomer.new
  field :editCustomer, function: Resolvers::EditCustomer.new
  field :destroyCustomer, function: Resolvers::DestroyCustomer.new

  # Reservations
  field :createReservation, function: Resolvers::CreateReservation.new
  field :createReservationFuzzyCustomer, function: Resolvers::CreateReservationFuzzyCustomer.new
  field :createReservationGuestCustomer, function: Resolvers::CreateReservationGuestCustomer.new
  field :createReservationAnyCustomer, function: Resolvers::CreateReservationAnyCustomer.new
  field :editReservation, function: Resolvers::EditReservation.new
  field :destroyReservation, function: Resolvers::DestroyReservation.new

  # Shift notes
  field :createShiftNote, function: Resolvers::CreateShiftNote.new
  field :editShiftNote, function: Resolvers::EditShiftNote.new

  # Floor plans
  field :createFloorPlan, function: Resolvers::CreateFloorPlan.new
  field :editFloorPlan, function: Resolvers::EditFloorPlan.new
  field :destroyFloorPlan, function: Resolvers::DestroyFloorPlan.new

  # Reservation plans
  field :destroyReservationPlan, function: Resolvers::DestroyReservationPlan.new
  field :editReservationPlan, function: Resolvers::ReservationPlans::EditReservationPlan.new
  field :createReservationPlan, function: Resolvers::ReservationPlans::CreateReservationPlan.new
end
