Rails.application.routes.draw do
  devise_for :users

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"
  post "/sms", to: "application#sms"
end
