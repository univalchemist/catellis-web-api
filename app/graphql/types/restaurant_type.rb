Types::RestaurantType = GraphQL::ObjectType.define do
  name 'Restaurant'
  require 'json'

  field :id, !types.ID
  field :name, !types.String
  field :timezone_name, !types.String
  field :rest_open_at, !types.String do
    # More on custom fields:
    # http://graphql-ruby.org/fields/introduction.html
    resolve ->(obj, args, ctx) {
      obj.rest_open_at.iso8601
    }
  end
  field :rest_close_at, !types.String do
    # More on custom fields:
    # http://graphql-ruby.org/fields/introduction.html
    resolve ->(obj, args, ctx) {
      obj.rest_close_at.iso8601
    }
  end
  field :online, types.Boolean
  field :max_party_size, types.Int
  field :min_party_size, types.Int
  field :online_days_in_advance, types.Int
  field :kitchen_pacing, types.Int
  field :email_confirmation_inhouse, types.Boolean
  field :email_confirmation_notes, types.String
  field :email_reminders, types.Boolean
  field :email_reminder_time, types.String
  field :notification_email_address, types.String
  field :created_notification, types.Boolean
  field :edited_notification, types.Boolean
  field :cancelled_notification, types.Boolean
  field :location, types.String
  field :phone_number, types.String
  field :turn_time_1, types.String
  field :turn_time_2, types.String
  field :turn_time_3, types.String
  field :turn_time_4, types.String
  field :turn_time_5, types.String
  field :turn_time_6, types.String
  field :turn_time_7, types.String
  field :turn_time_8, types.String
  field :turn_time_9, types.String
  field :turn_time_10, types.String
  field :turn_time_11, types.String
  field :turn_time_12, types.String
  field :turn_time_13, types.String
  field :turn_time_14, types.String
  field :turn_time_15, types.String
  field :turn_time_16, types.String
  field :turn_time_17, types.String
  field :turn_time_18, types.String
  field :turn_time_19, types.String
  field :turn_time_20, types.String
end
