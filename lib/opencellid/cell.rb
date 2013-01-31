require 'rexml/document'
require_relative 'utils'

module Opencellid

  # Models a Cell object, both as an output from the server and as an input to queries. When using an object of this type
  # to specify query parameters, the class attributes that should be used as filters should be set to the desired values,
  # while the other attributes should be set to nil
  class Cell

    attr_accessor :lat, :lon, :id, :mnc, :mcc, :lac, :range, :measures, :no_of_samples

    # @param id [Integer] the id of the cell
    # @param mnc [Integer] the mnc code of the cell
    # @param mcc [Integer] the mcc code of the cell
    # @param lac [Integer] the lac code of the cell
    def initialize(id, mnc, mcc, lac)
      @id = id
      @mnc = mnc
      @mcc = mcc
      @lac = lac
      @measures = []
    end

    # Parses the given element setting the information into a Cell object
    # @param element [REXML::Element] the XML element containing the representation of the Cell element
    # @return [Cell] the Cell object obtained by parsing the XML
    def self.from_element(element)
      return nil unless element
      raise ArgumentError, 'element must be of type XEXML::Element' unless element.is_a? REXML::Element
      raise ArgumentError, 'element must be a <cell>' unless element.name == 'cell'
      attrs = element.attributes

      result = Cell.new(::Opencellid.to_i_or_nil(attrs['cellId']), ::Opencellid.to_i_or_nil(attrs['mnc']),
                        ::Opencellid.to_i_or_nil(attrs['mcc']),::Opencellid.to_i_or_nil(attrs['lac']))
      result.lat = ::Opencellid.to_f_or_nil(attrs['lat'])
      result.lon = ::Opencellid.to_f_or_nil(attrs['lon'])
      result.range = ::Opencellid.to_i_or_nil(attrs['range'])
      result.no_of_samples= ::Opencellid.to_i_or_nil(attrs['nbSamples'])
      element.elements.each('measure') { |e| result.add_measure Measure.from_element e}
      result
    end


    # Indicates whether this cell contains measure objects
    # @return [bool] whether this cell contains measure objects
    def has_measures?
      @measures.count > 0
    end

    # Adds a new measure to this cell
    # @param measure [Measure] a measure object to be added to this cell. Note that adding the object to the cell
    # does NOT result in an add_measure call being invoked on the Opencellid object
    def add_measure(measure)
      @measures << measure
    end

    # Helper function that transforms the parameters of this cell in a hash of query parameters to be used
    # with the library cell querying functions
    # @return [Hash] a hash object containing the non nil parameters which can be used in while querying for cells
    def to_query_hash
      {cellid: id, mnc: mnc, mcc: mcc, lac: lac}.delete_if {|_,v| v.nil?}
    end

    # Returns an array containing the longitude and latitude of the cell, this method makes the Cell
    # object to be compatible with mongoid_spacial gem
    # @return [Array] an array containing longitude and latitude of the cell.
    def to_lng_lat
      [lon, lat]
    end

  end

end