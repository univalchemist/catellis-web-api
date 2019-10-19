require 'query_support'

class Customers::ListCustomersService < BaseService
  Result = build_result_struct(:customers)

  def perform(args:, ctx:)
    current_user = ctx[:current_user]

    scope = ::RestaurantScopePolicy::Scope.new(current_user, Customer)
    customers = scope.resolve

    unless args[:search_text].nil?
      # TODO: This is a better text search than just a basic ILIKE, but it's
      #   still not very advanced, and it still won't return partial matches.
      #   This is fine for phase 1, but later phases will likely need to have
      #   a more advanced search engine/algorithm.

      search_values = QuerySupport.sanitize_tokenize_like_input(args[:search_text])

      name_where = customers.where(
        "name ILIKE :name",
        name: "%#{search_values}%"
      )

      phone_values = QuerySupport.sanitize_phone_number(args[:search_text])
      phone_where = nil
      unless phone_values.empty?
        phone_where = customers.where(
          "phone_number ILIKE :phone_number",
          phone_number: "%#{phone_values}%"
        )
      end

      customers = name_where
      if phone_where.present?
        customers = customers.or(phone_where)
      end
    end

    customers = customers.order(name: :asc, updated_at: :desc)

    Result.new(
      success: true,
      customers: customers
    )
  end
end
