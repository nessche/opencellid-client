require_relative 'utils'

module Opencellid

  # A class which models the measurement of a cell position
  class Measure

    # The format used by the OpenCellId API to pass date/time information
    DATE_FORMAT = "%a %b %d %H:%M:%S %z %Y"

    attr_accessor :lat, :lon, :taken_by, :taken_on, :id, :signal

    # @param lat [Float] the latitude of the position measured
    # @param lon [Float] the longitude of the position measured
    # @param taken_on [DateTime] the date/time information at which the measurement was taken
    def initialize(lat, lon, taken_on = nil)
      @lat = lat
      @lon = lon
      @taken_on = taken_on
    end


    # @param element [REXML::Element] the XML element containing the representation of the measurement
    # @return [Measure] the Measure object obtained by parsing the XML
    def self.from_element(element)
      return nil unless element
      raise ArgumentError, "element must be of type XEXML::Element" unless element.is_a? REXML::Element
      raise ArgumentError, "element must be a <measure>" unless element.name == "measure"
      attrs = element.attributes
      date = attrs['takenOn']
      date ||= attrs['measured_at']
      measure =  Measure.new(::Opencellid::to_f_or_nil(attrs['lat']),::Opencellid::to_f_or_nil(attrs['lon']),
                             ::Opencellid::to_datetime_or_nil(date,DATE_FORMAT))
      measure.id = ::Opencellid.to_i_or_nil(attrs['id'])
      measure.taken_by= attrs['takenBy']
      measure.signal = ::Opencellid.to_i_or_nil(attrs['signal'])
      measure
    end

  end

end