module Opencellid

  # A class to simplify the setting the coordinates of a bounding box while calling methods on the
  # OpenCellId API
  class BBox

    attr_accessor :latmin, :lonmin, :latmax, :lonmax

    # @param latmin [Float] latmin the latitude of the SW corner of the box
    # @param lonmin [Float] lonmin the longitude of the SW corner of the box
    # @param latmax [Float] latmax the latitude of the NE corner of the box
    # @param lonmax [Float] lonmax the longitude of the NE corner of the box
    def initialize(latmin, lonmin, latmax, lonmax)
      raise ArgumentError, "latmin must not be nil" unless latmin
      raise ArgumentError, "lonmin must not be nil" unless lonmin
      raise ArgumentError, "latmax must not be nil" unless latmax
      raise ArgumentError, "lonmax must not be nil" unless lonmax
      @latmin = latmin
      @lonmin = lonmin
      @latmax = latmax
      @lonmax = lonmax
    end

    # Transforms the coordinates of this bounding box in a format suitable for the OpenCellId API
    # @return [String] the coordinates of the bbox is a format compatible with the OpenCellId API
    def to_s
      "#{latmin},#{lonmin},#{latmax},#{lonmax}"
    end

  end



end