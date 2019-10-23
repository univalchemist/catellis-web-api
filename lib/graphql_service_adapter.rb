module GraphQlServiceAdapter
  def self.perform(service, result_sym, args, ctx)
    service_instance = service.new

    result = service_instance.perform(
      args: args,
      ctx: ctx
    )

    result.public_send(result_sym)
  end
end
