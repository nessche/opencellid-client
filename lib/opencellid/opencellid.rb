require 'rexml/document'
require 'net/http'
require_relative 'cell'
require_relative 'response'
require_relative 'measure'
require_relative 'bbox'
require_relative 'error'

module Opencellid

  # The main entry for this library. Each method maps to the corresponding method of the
  # OpenCellId API defined at {http:://www.opencellid.org/api}.
  class Opencellid

    DEFAULT_URI = "http://www.opencellid.org"
    GET_IN_AREA_ALLOWED_PARAMS = [:limit, :mcc, :mnc]
    attr_reader :key

    # @param key [String] the API key used for "write" operations. Defaults to nil
    def initialize(key=nil)
      @key = key
    end

    # Retrieves the cell information based on the parameters specified inside the `cell` object
    # @param[Cell] cell the object containing the parameters to be used in searching the database
    # the result received from the server
    def get_cell(cell)
      query_cell_info "/cell/get", cell
    end

    # Retrieves the cell information and the measures used to calculate its position based on the parameters
    # specified in the cell object
    # @param[Cell] cell the object containing the parameters used to search the cell database
    # @return[Response] the result received from the server
    def get_cell_measures(cell)
      query_cell_info "/cell/getMeasures", cell
    end

    # Retrieves all the cells located inside the bounding box and whose parameters match the ones specified in the options
    # @param bbox [BBox] the bounding box limiting the cell search
    # @param options [Hash] a hash containing further filtering criteria. Valid criteria are `:limit` (limiting the amount
    # of results), `:mnc` specifying the mnc value of the desired cells and `:mcc` specifying the mcc value of the desired cells
    # @return [Response] the result received from the server
    def get_cells_in_area(bbox, options = {})
      raise ArgumentError, "options must be a Hash" unless options.is_a? Hash
      raise ArgumentError, "bbox must be of type BBox" unless bbox.is_a? BBox
      params = {bbox: bbox.to_s, fmt: 'xml'}
      params.merge!(options.reject { |key| !GET_IN_AREA_ALLOWED_PARAMS.include? key})
      execute_request_and_parse_response "/cell/getInArea", params
    end

    # Adds a measure (specified by the measure object) to a given cell (specified by the cell object). In case of
    # success the response object will also contain the cell_id and the measure_id of the newly created measure.
    # Although the library does not check this, a valid APIkey must have been specified while initializing the
    # this object
    # @param cell [Object] the cell to which this measure must be added to
    # @param measure [Object] the measure to be added
    # @return [Response] the result obtained from the server
    def add_measure(cell, measure)
      raise ArgumentError, "cell must be of type Cell" unless cell.is_a? Cell
      raise ArgumentError, "measure must be of type Measure" unless measure.is_a? Measure
      params = cell.to_query_hash
      params[:lat] = measure.lat
      params[:lon] = measure.lon
      params[:signal] = measure.signal if measure.signal
      params[:measured_at] = measure.taken_on if measure.taken_on
      execute_request_and_parse_response "/measure/add", params
    end

    # List the measures added with a given API key.
    # @return [Response] the result received from the server
    def list_measures
      execute_request_and_parse_response "/measure/list"
    end

    # Deletes a measure previously added with the same API key.
    # @param measure_id [Integer] the id of the measure to be deleted (obtained in the response from `add_measure` or via `list_measures`)
    # @return [Response] the result received from the server
    def delete_measure(measure_id)
      raise ArgumentError,"measure_id cannot be nil" unless measure_id
      execute_request_and_parse_response "/measure/delete", {id: measure_id}
    end

  protected

    def query_cell_info(path, cell)
      raise ArgumentError, "cell must be a Cell" unless cell.is_a? Cell
      params = cell.to_query_hash
      execute_request_and_parse_response path, params
    end

    def execute_request_and_parse_response(path, params = {})
      params[:key] = @key if @key
      uri = URI(DEFAULT_URI + path)
      uri.query = URI.encode_www_form params if params.count > 0
      res = Net::HTTP.get_response uri
      if res.is_a? Net::HTTPOK
        Response.from_xml res.body
      else
        response = Response.new false
        response.error = ::Opencellid::Error.new(0, "Http Request failed with code #{res.code}")
        response
      end
    end

  end

end