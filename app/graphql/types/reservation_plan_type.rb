Types::ReservationPlanType = GraphQL::ObjectType.define do
  name 'ReservationPlan'

  field :restaurant, !Types::RestaurantType
  field :id, !types.ID
  field :name, !types.String
  field :repeat, !types.String
  field :priority, !types.Int
  field :effective_date_start_at, !types.String do
    resolve ->(obj, args, ctx) {
      obj.effective_date_start_at.iso8601
    }
  end
  field :effective_date_end_at, !types.String do
    resolve ->(obj, args, ctx) {
      obj.effective_date_end_at.iso8601
    }
  end
  field :effective_time_start_at, !types.String do
    resolve ->(obj, args, ctx) {
      obj.effective_time_start_at.iso8601
    }
  end
  field :effective_time_end_at, !types.String do
    resolve ->(obj, args, ctx) {
      obj.effective_time_end_at.iso8601
    }
  end
  field :cust_reservable_start_at, !types.String do
    resolve ->(obj, args, ctx) {
      obj.cust_reservable_start_at.iso8601
    }
  end
  field :cust_reservable_end_at, !types.String do
    resolve ->(obj, args, ctx) {
      obj.cust_reservable_end_at.iso8601
    }
  end
  field :active_weekday_0, !types.Boolean
  field :active_weekday_1, !types.Boolean
  field :active_weekday_2, !types.Boolean
  field :active_weekday_3, !types.Boolean
  field :active_weekday_4, !types.Boolean
  field :active_weekday_5, !types.Boolean
  field :active_weekday_6, !types.Boolean
  field :floor_plans, !types[Types::FloorPlanType]
  field :reservation_plan_floor_plans, !types[Types::ReservationPlanFloorPlanType]
end
