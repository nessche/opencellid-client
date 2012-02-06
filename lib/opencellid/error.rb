require 'rexml/document'
require_relative 'utils'

module Opencellid

  # Models an error object received from the server
  class Error

    attr_accessor :info, :code

    # @param code [Integer] the code identifying this error
    # @param info [String] a human readable explanation of the error
    def initialize(code, info)
      @info = info
      @code = code
    end

    # @param element [REXML::Element] an XML element containing the error
    # @return [Error] the error object created by parsing the XML element
    def self.from_element(element)
      return nil unless element
      raise ArgumentError, "element must be of type XEXML::Element" unless element.is_a? REXML::Element
      raise ArgumentError, "element must be an <err>" unless element.name == "err"
      attrs = element.attributes
      return Error.new(::Opencellid.to_i_or_nil(attrs['code']),attrs['info'])
    end

  end

end