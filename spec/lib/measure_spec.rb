require 'spec_helper'
require 'opencellid'
require 'rexml/document'

module Opencellid

  WELL_CELL_SUB = '<measure lat="60.3277783333333" lon="24.8693505" takenOn="Fri Jul 22 15:02:17 +0200 2011" takenBy="4207"></measure>'
  MEASURE_LIST_SUB = '<measure measured_at="Fri Jul 22 10:10:10 +0200 2011" lat="1.0" mcc="1" lon="2.0" signal="10" cellId="2" mnc="1" id="56216430" lac="4"/>'
  describe "Measure" do

    describe "from_element" do

      context "when passed a well formed measure" do

        it "should parse the cell sub-element correctly" do
          doc = REXML::Document.new WELL_CELL_SUB
          measure = Measure.from_element doc.root
          measure.should be_a Measure
          measure.lat.should == 60.3277783333333
          measure.lon.should == 24.8693505
          measure.taken_by.should == "4207"
          measure.signal.should be_nil
          measure.id.should be_nil
          expected_data = DateTime.new(2011,7,22,15,2,17,Rational(2,24))
          measure.taken_on.should == expected_data
        end

        it "should parse the measure list sub-element correctly" do
          doc = REXML::Document.new MEASURE_LIST_SUB
          measure = Measure.from_element doc.root
          measure.should be_a Measure
          measure.lat.should == 1.0
          measure.lon.should == 2.0
          measure.id.should == 56216430
          measure.taken_by.should be_nil
          expected_data = DateTime.new(2011,7,22,10,10,10,Rational(2,24))
          measure.taken_on.should == expected_data
        end

      end

      context "when passed nil" do

        it "should return nil" do
          Measure.from_element(nil).should be_nil
        end

      end

      context "when passing something else than an XML element" do

        it "should raise an ArgumentError" do
          expect{Measure.from_element "This is just a String"}. to raise_error ArgumentError
        end


      end

      context "when passed something else then a measure" do

        it "should raise an Argument Error" do
          doc = REXML::Document.new "<a>this is not a measure</a>"
          expect{Measure.from_element doc}.to raise_error ArgumentError
        end


      end

    end

  end

end