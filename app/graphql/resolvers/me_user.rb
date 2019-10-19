class Resolvers::MeUser < GraphQL::Function
  type Types::UserType

  def call(obj, args, ctx)
    ctx[:current_user]
  end
end
