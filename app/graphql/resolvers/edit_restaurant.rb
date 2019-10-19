require 'json'

class Resolvers::EditRestaurant < GraphQL::Function
  argument :id, !types.ID
  argument :name, types.String
  argument :timezone_name, types.String
  argument :rest_open_at, types.String
  argument :rest_close_at, types.String
  argument :online, types.Boolean
  argument :max_party_size, types.Int
  argument :min_party_size, types.Int
  argument :online_days_in_advance, types.Int
  argument :kitchen_pacing, types.Int

  argument :email_confirmation_inhouse, types.Boolean
  argument :email_confirmation_notes, types.String
  argument :email_reminders, types.Boolean
  argument :email_reminder_time, types.String
  argument :notification_email_address, types.String
  argument :created_notification, types.Boolean
  argument :edited_notification, types.Boolean
  argument :cancelled_notification, types.Boolean
  argument :turn_time_1, types.String
  argument :turn_time_2, types.String
  argument :turn_time_3, types.String
  argument :turn_time_4, types.String
  argument :turn_time_5, types.String
  argument :turn_time_6, types.String
  argument :turn_time_7, types.String
  argument :turn_time_8, types.String
  argument :turn_time_9, types.String
  argument :turn_time_10, types.String
  argument :turn_time_11, types.String
  argument :turn_time_12, types.String
  argument :turn_time_13, types.String
  argument :turn_time_14, types.String
  argument :turn_time_15, types.String
  argument :turn_time_16, types.String
  argument :turn_time_17, types.String
  argument :turn_time_18, types.String
  argument :turn_time_19, types.String
  argument :turn_time_20, types.String
  argument :location, types.String
  argument :phone_number, types.String

  type Types::RestaurantType

  def call(obj, args, ctx)
    current_user = ctx[:current_user]

    return GraphQL::ExecutionError.new("requires authentication") unless current_user

    restaurants = ::RestaurantPolicy::Scope.new(current_user, Restaurant).resolve
    restaurant = restaurants.find(args[:id])

    # Clean up arguments.
    args_hash = args.to_h.deep_symbolize_keys
    update_params = args_hash
      .slice(
        :name,
        :timezone_name,
        :rest_open_at,
        :rest_close_at,
        :online,
        :max_party_size,
        :min_party_size,
        :online_days_in_advance,
        :kitchen_pacing,
        :email_confirmation_inhouse,
        :email_confirmation_notes,
        :email_reminders,
        :email_reminder_time,
        :notification_email_address,
        :created_notification,
        :edited_notification,
        :cancelled_notification,
        :turn_time_1,
        :turn_time_2,
        :turn_time_3,
        :turn_time_4,
        :turn_time_5,
        :turn_time_6,
        :turn_time_7,
        :turn_time_8,
        :turn_time_9,
        :turn_time_10,
        :turn_time_11,
        :turn_time_12,
        :turn_time_13,
        :turn_time_14,
        :turn_time_15,
        :turn_time_16,
        :turn_time_17,
        :turn_time_18,
        :turn_time_19,
        :turn_time_20,
        :phone_number,
        :location
      )

    restaurant.attributes = update_params

    restaurant.save!

    restaurant
  end
end
