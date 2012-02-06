require 'spec_helper'
require 'opencellid'

module Opencellid

  describe Opencellid do

    before do
      WebMock.disable_net_connect!
      stub_request(:get, /www\.opencellid\.org/).to_return(status: 200, body: data_file_as_string('one_cell.xml'))
      @oci = Opencellid.new
      @response = double(:response)
      Response.stub(:from_xml).and_return(@response)
    end

    describe "execute_request_and_parse_response" do

      before do
        @method = @oci.method(:execute_request_and_parse_response)

      end

      context "when the api key is specified" do

        before do
          @oci = Opencellid.new "myapikey"
          @method = @oci.method(:execute_request_and_parse_response)
        end

        it "should add it to the parameters" do
          @method.call("/")
          WebMock.should have_requested(:get, "www.opencellid.org/")
                         .with(query: { "key" => "myapikey"})
        end

      end

      context "when the api key is not specified" do

        it "should not add it to the parameters" do
          @method.call("/")
          WebMock.should have_requested(:get, "www.opencellid.org/")
        end

      end

      it "should add the params as query params" do

        @method.call("/",{"a" => "10", "b" => "20", "c" => "30"})
        WebMock.should have_requested(:get, "www.opencellid.org/")
                       .with(query: {"a" => "10", "b" => "20", "c" => "30"})
      end

      it "should set the path correctly" do
        @method.call("/mypath")
        WebMock.should have_requested(:get, "www.opencellid.org/mypath")
      end

      context "when HTTP Response status is 200" do

        it "should invoke from_xml on Response" do
          expected_xml = data_file_as_string('one_cell.xml')
          Response.should_receive(:from_xml).with(expected_xml)
          @method.call("/")
        end

        it "should return the Response object" do
          @method.call("/").should == @response
        end

      end

      context "when HTTP Response is not 200" do

        before do
          stub_request(:get, /www\.opencellid\.org/).to_return(status: 500, body: "Internal Server Error")
        end

        it "should return a response of type failure" do
          response = @method.call("/")
          response.should_not be_ok
          response.error.code.should == 0
          response.error.info.should == "Http Request failed with code 500"
        end

      end

    end

    describe "get_cell" do

      context "when parameter is not a Cell" do

        it "should raise an ArgumentError" do
          expect{@oci.get_cell nil}.to raise_error ArgumentError
          expect{@oci.get_cell "This is a not a Cell"}.to raise_error ArgumentError
        end

      end

      it "should set the correct path and parameters" do
        @oci.get_cell(Cell.new(1,2,3,4))
        WebMock.should have_requested(:get, "www.opencellid.org/cell/get")
                       .with(query: {"cellid" => "1", "mnc" => "2", "mcc" => "3", "lac" => "4"})
      end

      it "should return a response" do
        @oci.get_cell(Cell.new(1,2,3,4)).should == @response
      end

    end

    describe "get_cell_measures" do

      context "when parameter is not a Cell" do

        it "should raise an ArgumentError" do
          expect{@oci.get_cell_measures nil}.to raise_error ArgumentError
          expect{@oci.get_cell_measures "This is a not a Cell"}.to raise_error ArgumentError
        end

      end

      it "should set the correct path and parameters" do
        @oci.get_cell_measures(Cell.new(1,2,3,4))
        WebMock.should have_requested(:get, "www.opencellid.org/cell/getMeasures")
                       .with(query: {"cellid" => "1", "mnc" => "2", "mcc" => "3", "lac" => "4"})
      end

      it "should return a response" do
        @oci.get_cell_measures(Cell.new(1,2,3,4)).should == @response
      end

    end

    describe "get_cells_in_area" do

      before do
        @bbox = BBox.new(1.0,2.0,3.0,4.0)
        @options = {mnc: 10, mcc: 20, limit: 30}
      end

      context "when parameters are not of right type" do

        it "should raise an ArgumentError" do
          expect{@oci.get_cells_in_area nil, @options}.to raise_error ArgumentError
          expect{@oci.get_cells_in_area "This is a not a BBox", @options}.to raise_error ArgumentError
          expect{@oci.get_cells_in_area @bbox, "This is not a hash" }.to raise_error ArgumentError
        end

      end

      it "should set the correct path" do
        @oci.get_cells_in_area(@bbox)
        WebMock.should have_requested(:get, "www.opencellid.org/cell/getInArea")
                       .with(query: {"bbox" => @bbox.to_s, "fmt" => "xml"})
      end

      it "should filter out invalid parameters from options" do
        @oci.get_cells_in_area(@bbox, mnc: 20, invalid_params: 50, limit: 30, mcc: 60)
        WebMock.should have_requested(:get, "www.opencellid.org/cell/getInArea")
                       .with(query: {"bbox" => @bbox.to_s, "fmt" => "xml", "mnc" => "20", "mcc" => "60", "limit" => "30"})

      end

      it "should return a response" do
        @oci.get_cells_in_area(@bbox).should == @response
      end

    end

    describe "add_measure" do

      before do
        @cell = Cell.new(1,2,3,4)
        @measured_at = DateTime.new(2011,7,22,10,10,10,Rational(2,24))
        @measure = Measure.new(1.0, 2.0, @measured_at)
        @measure.signal = 10
      end

      context "when parameters are of wrong type" do

        it "should raise an ArgumentError" do
          expect{@oci.add_measure nil, @measure}.to raise_error ArgumentError
          expect{@oci.add_measure "This is not a Cell", @measure}.to raise_error ArgumentError
          expect{@oci.add_measure @cell, nil}.to raise_error ArgumentError
          expect{@oci.add_measure @cell, "This is not a measure"}.to raise_error ArgumentError
        end

      end

      it "should set the correct path and parameters" do
        @oci.add_measure(@cell, @measure)
        WebMock.should have_requested(:get, "www.opencellid.org/measure/add")
                       .with(query: {"cellid" => "1", "mnc" => "2", "mcc" => "3", "lac" => "4",
                                     "lat" => "1.0", "lon" => "2.0", "measured_at" => @measured_at.to_s, "signal" => "10"})
      end

      it "should return a response" do
        @oci.add_measure(@cell, @measure).should == @response
      end

    end

    describe "list_measures" do

      it "should set the correct path and parameters" do
        @oci.list_measures
        WebMock.should have_requested(:get, "www.opencellid.org/measure/list")
      end

      it "should return a response" do
        @oci.list_measures.should == @response
      end

    end

    describe "delete_measure" do

      context "when measure_id is nil" do

        it "should raise an ArgumentError" do
          expect{@oci.delete_measure nil}.to raise_error ArgumentError
        end

      end

      it "should set the correct path and parameters" do
        @oci.delete_measure 30
        WebMock.should have_requested(:get, "www.opencellid.org/measure/delete")
                       .with(query: {"id" => "30"})
      end

      it "should return a response" do
        @oci.delete_measure(30).should == @response
      end

    end

  end

end