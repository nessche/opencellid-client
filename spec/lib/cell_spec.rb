require 'spec_helper'
require 'opencellid'
require 'rexml/document'

module Opencellid

  WELL_FORMED_CELL =  '<cell lat="60.3276113" mcc="244" lon="24.8689952" nbSamples="5" cellId="118135" mnc="91" lac="" range="6000"/>'
  WELL_FORMED_CELL_WITH_MEASURE = <<XML

  <cell lat="60.3276113" mcc="244" lon="24.8689952" cellId="118135" nbSamples="5" mnc="91" lac="" range="6000">
    <measure lat="60.3277783333333" lon="24.8693505" takenOn="Fri Jul 22 15:02:17 +0200 2011" takenBy="4207"></measure>
    <measure lat="60.3275705" lon="24.8689813333333" takenOn="Sun Aug 07 23:22:04 +0200 2011" takenBy="4207"></measure>
    <measure lat="60.3273111666667" lon="24.867736" takenOn="Mon Aug 08 11:10:47 +0200 2011" takenBy="4207"></measure>
    <measure lat="60.3278625" lon="24.8698973333333" takenOn="Mon Aug 08 12:31:59 +0200 2011" takenBy="4207"></measure>
    <measure lat="60.327534" lon="24.8690108333333" takenOn="Mon Aug 08 12:32:03 +0200 2011" takenBy="4207"></measure>
  </cell>

XML

  describe "Cell" do

    describe "from_element" do

      context "when passed a well formed XML" do

        it "should parse the cell attributes correctly" do

          doc = REXML::Document.new WELL_FORMED_CELL
          result = Cell.from_element(doc.root)
          result.should be_a Cell
          result.lat.should == 60.3276113
          result.lon.should == 24.8689952
          result.mcc.should == 244
          result.mnc.should == 91
          result.no_of_samples.should == 5
          result.id.should == 118135
          result.lac.should be_nil
          result.range.should == 6000

        end


      end

      context "when passed nil" do

        it "should return nil" do
          Cell.from_element(nil).should be_nil
        end

      end

      context "when passed something else than an XML element" do

        it "should raise an ArgumentError" do
          expect{Cell.from_element "This is just a String"}.to raise_error ArgumentError
        end

      end

      context "when passed an XML element not of type cell" do

        it "should raise an ArgumentError" do
          doc = REXML::Document.new "<a>This is not a cell</a>"
          expect{Cell.from_element doc}.to raise_error ArgumentError
        end

      end

    end

    describe "has_measures?" do

      context "when measures array is empty" do

        it "should return false" do
          cell = Cell.new(1,2,3,4)
          cell.has_measures?.should be_false
        end

      end

      context "when measures array is not empty" do

        it "should return true" do
          cell = Cell.new(1,2,3,4)
          cell.add_measure(Measure.new(1.0,1.0))
          cell.has_measures?.should be_true
        end

      end

    end

    describe "to_query_hash" do

      it "should return a hash" do
        Cell.new(1,2,3,4).to_query_hash.should be_a Hash
      end

      it "should only have query parameters" do
        cell = Cell.new(1,2,3,4)
        cell.range = 3000
        cell.add_measure Measure.new(1.0,1.0)
        hash = cell.to_query_hash
        hash.count.should == 4
        hash.should include :cellid
        hash.should include :mnc
        hash.should include :mcc
        hash.should include :lac

      end

      it "should have parameters correctly mapped" do
        cell = Cell.new(1,2,3,4)
        hash = cell.to_query_hash
        hash[:cellid].should == 1
        hash[:mnc].should == 2
        hash[:mcc].should == 3
        hash[:lac].should == 4

      end

      it "should leave out nil parameters" do
        Cell.new(nil,2,3,4).to_query_hash.should_not include :cellid
        Cell.new(1,nil,3,4).to_query_hash.should_not include :mnc
        Cell.new(1,2,nil,4).to_query_hash.should_not include :mcc
        Cell.new(1,2,3,nil).to_query_hash.should_not include :lac
      end


    end



  end

end