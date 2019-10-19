module QuerySupport
  def self.normalize_and_strip(search_value)
    search_value
      .gsub(/\s+/m, ' ')
      .gsub(/[^\w\s]/, '')
      .strip
  end

  # Sanitize and tokenize text values
  # This allows for searches like 'Jon Stewart' to match customers
  # named 'Jonathan Stewart'.
  def self.sanitize_tokenize_like_input(search_value)
    normalize_and_strip(search_value)
      .split(' ')
      .join('%')
  end

  def self.sanitize_phone_number(search_value)
    search_value
      .gsub(/\D/, '')
      .strip
  end
end
