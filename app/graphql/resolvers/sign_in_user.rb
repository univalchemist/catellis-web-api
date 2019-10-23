class Resolvers::SignInUser < GraphQL::Function
  argument :email, !types.String
  argument :password, !types.String

  type Types::AuthenticateType

  def call(obj, args, ctx)
    user = User.find_by_email(args[:email])

    if user.nil? || !user.valid_password?(args[:password])
      return GraphQL::ExecutionError.new("invalid credentials")
    end

    OpenStruct.new({
      user: user,
      token: AuthToken.token(user)
    })
  end
end
