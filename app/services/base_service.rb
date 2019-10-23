class BaseService
  Result = ImmutableStruct.new(:success?, :error)

  def self.build_result_struct(*args)
    ImmutableStruct.new(:success?, :error, *args)
  end

  def error_result(error)
    Result.new(success: false, error: error)
  end
end
