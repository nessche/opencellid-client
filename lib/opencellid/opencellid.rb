require 'rexml/document'
require 'net/http'

module Opencellid

  class Opencellid

    DEFAULT_URI = "http://www.opencellid.org"
    GET_ALLOWED_PARAMS = [:mcc, :mnc, :lac, :cellid]
    attr_reader :key

    def initialize(key=nil)
      @key = key
    end

    def get(options)
      uri = URI(DEFAULT_URI + "/cell/get")
      params = options.reject { |key| !GET_ALLOWED_PARAMS.include? key}
      params[:key] = @key if @key
      uri.query = URI.encode_www_form params
      puts URI.encode_www_form(params)
      res = Net::HTTP.get_response uri
      puts res.body
      response = Response.new res.body
      response
    end



  end

  class Response

    def initialize(string)
      @doc = REXML::Document.new string
      raise RuntimeError, "Could not parse server response" unless @doc
      raise RuntimeError, "The server response does not contain a valid response" unless @doc.root.name == "rsp"
    end

    def ok?
      @doc.root.attributes['stat'] == "ok"
    end

    def cell
      Cell.from_element @doc.root.elements['cell']
    end

    def failed?
      @doc.root.attributes['stat'] == "fail"
    end

    def error
      Error.from_element @doc.root.elements['err']
    end


  end

  class Cell

    attr_accessor :lat, :lon, :id, :mnc, :mcc, :lac, :range

    def initialize(id, mnc, mcc, lat, lon, lac, range)
      @id = id
      @mnc = mnc
      @mcc = mcc
      @lat = lat
      @lon = lon
      @lac = lac
      @range = range
    end

    def self.from_element(element)
      return nil unless element
      raise ArgumentError, "element must be of type XEXML::Element" unless element.is_a? REXML::Element
      attrs = element.attributes
      return Cell.new(attrs['cellId'].to_i,attrs['mnc'].to_i,attrs['mcc'].to_i,
                      attrs['lat'].to_f,attrs['lon'].to_f,attrs['lac'].to_i,attrs['range'].to_i)
    end




  end

  class Error

    attr_accessor :info, :code

    def initialize(code, info)
      @info = info
      @code = code
    end

    def self.from_element(element)
      return nil unless element
      raise ArgumentError, "element must be of type XEXML::Element" unless element.is_a? REXML::Element
      attrs = element.attributes
      return Error.new(attrs['code'].to_i,attrs['info'])
    end

  end


end