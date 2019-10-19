Types::CustomerType = GraphQL::ObjectType.define do
  name 'Customer'

  field :id, !types.ID
  field :restaurant, !Types::RestaurantType
  field :name, !types.String
  field :phone_number, !types.String
  field :email, types.String
  field :tags, types.String
end
