require 'spec_helper'
require 'opencellid'

module Opencellid

  WELL_FORMED_ERROR = '<err info="cell not found" code="1"/>'

  describe Error do

    describe "from_element" do

      context "when passed a well formed error" do

        it "should parse the XML correctly" do
          doc = REXML::Document.new WELL_FORMED_ERROR
          error = Error.from_element doc.root
          error.should be_a Error
          error.code.should == 1
          error.info.should == "cell not found"
        end

      end

      context "when passed nil" do

        it "should return nil" do
          Error.from_element(nil).should be_nil
        end

      end

      context "when passing something else than an XML element" do

        it "should raise an ArgumentError" do
          expect{Error.from_element "This is just a String"}. to raise_error ArgumentError
        end


      end

      context "when passed something else then a measure" do

        it "should raise an Argument Error" do
          doc = REXML::Document.new "<a>this is not an error</a>"
          expect{Error.from_element doc}.to raise_error ArgumentError
        end


      end

    end



  end


end