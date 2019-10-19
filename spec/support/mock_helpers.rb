module MockHelpers
  def quick_instance_double(target_class, props, call_count = 1)
    mock = instance_double(target_class)

    props.keys.each do |key|
      response = props[key]
      expect(mock).to(
        receive(key.to_sym)
          .and_return(response)
          .exactly(call_count).times
      )
    end

    return mock
  end
end
