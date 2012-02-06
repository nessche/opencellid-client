module Opencellid

  # A helper function that avoids invoking `to_i` on a string when it is null or empty
  # @param string [String] the nullable string containing the data to transformed into an integer
  # @return [Integer] `nil` if the string passed is nil or empty, the result of `to_i` otherwise
  def self.to_i_or_nil(string)
    string and string.length > 0 ? string.to_i : nil
  end

  # A helper function that avoids invoking `to_f` on a string when it is null or empty
  # @param string [String] the nullable string containing the data to transformed into a float
  # @return [Float] `nil` if the string passed is nil or empty, the result of `to_f` otherwise
  def self.to_f_or_nil(string)
    string and string.length > 0 ? string.to_f : nil
  end

  # A helper function that avoids invoking `strptime` on a string when it is null or empty
  # @param string [String] the nullable string containing the data to transformed into a DateTime
  # @param format [String] the format string as specified by `strptime`
  # @return [DateTime] `nil` if the string passed is nil or empty, the result of `DateTime.strptime` otherwise
  def self.to_datetime_or_nil(string, format)
    string and string.length > 0 ? DateTime.strptime(string, format) : nil
  end

end