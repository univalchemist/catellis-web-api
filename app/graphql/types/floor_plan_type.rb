Types::FloorPlanType = GraphQL::ObjectType.define do
  name 'FloorPlan'

  field :id, !types.ID
  field :name, !types.String
  field :floor_plan_tables, !types[Types::FloorPlanTableType]
  field :created_at, !types.String do
    # More on custom fields:
    # http://graphql-ruby.org/fields/introduction.html
    resolve ->(obj, args, ctx) {
      obj.created_at.iso8601
    }
  end
end
