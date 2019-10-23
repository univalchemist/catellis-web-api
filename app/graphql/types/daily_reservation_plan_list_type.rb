Types::DailyReservationPlanListType = GraphQL::ObjectType.define do
  name 'DailyReservationPlanList'

  # NOTE: Assuming here that the ID will be identical to the effective_at value,
  # as the effective date is really the key here for this "resource".
  # They're being kept separate because I think combining the two into the ID
  # field isn't very intuitive for API clients.
  field :id, !types.ID
  field :effective_at, !types.String
  field :reservation_plans, !types[Types::ReservationPlanType]
end
