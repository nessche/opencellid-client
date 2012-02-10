require 'rexml/document'
require_relative 'error'
require_relative 'utils'

module Opencellid

  # The class modelling all possible answers from the server. Also when the server is not reachable or encounters an
  # error (e.g. a 500 response), the library will return a Response object, so that clients will not need to handle
  # application errors and HTTP errors separately
  class Response

    attr_accessor :cells, :error, :cell_id, :measure_id, :result, :measures


    # @param ok [bool]  whether the response is an ok response or a failure one
    def initialize(ok)
      @ok = ok
    end

    # Tells whether the response is a successful response or not
    # @return [bool] `true` if the response is a successful response
    def ok?
      @ok
    end

    # Tells whether the response is a failure response or not
    # @return [bool] `true` if the response is a failure response
    def failed?
      not @ok
    end

    # Parses the string containing the response as XML and returns the corresponding Response object
    # @param string [String] a string containing the XML response received from the server
    # @return [Response] the Response object obtained by parsing the XML file
    def self.from_xml(string)
      doc = REXML::Document.new string
      raise RuntimeError, "Could not parse server response" unless doc and doc.root
      case doc.root.name
        when "rsp"
          response = Response.new(doc.root.attributes['stat'] == "ok")
          response.measures = []
          if response.ok?
            response.cells= doc.root.elements.collect('cell') {|e| Cell.from_element e }
            response.cell_id = ::Opencellid.to_i_or_nil(doc.root.attributes['cellid'])
            response.measure_id = ::Opencellid.to_i_or_nil(doc.root.attributes['id'])
            res = doc.root.elements['res']
            response.result = res.text if res
          else
            response.cells = []
            response.error =  Error.from_element doc.root.elements['err']
          end
        when "measures"
          response = Response.new true
          response.measures = doc.root.elements.collect('measure') {|e| Measure.from_element e }
          response.cells = []
      else
        raise RuntimeError, "The server response does not contain a valid response"
      end
      response
    end


  end


end