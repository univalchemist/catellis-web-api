# Note: this file is purposefully named `_global` to ensure that is loads
# before other initializers. That will ensure that any other initializers can
# rely on a configured Global object.

Global.configure do |config|
  config.environment = Rails.env.to_s
  config.config_directory = Rails.root.join('config/global').to_s
end
