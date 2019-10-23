Types::AuthenticateType = GraphQL::ObjectType.define do
  name 'AuthenticateUser'

  field :user, !Types::UserType
  field :token, !types.String
end
