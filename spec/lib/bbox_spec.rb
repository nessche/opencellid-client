require 'spec_helper'
require 'opencellid'

module Opencellid

  describe BBox do

    describe "new" do

      context "when one or more parameters are nil" do

        it "should raise an ArgumentError" do
          expect{BBox.new(nil,1.0,1.0,1.0)}.to raise_error ArgumentError
          expect{BBox.new(1.0,nil,1.0,1.0)}.to raise_error ArgumentError
          expect{BBox.new(1.0,1.0,nil,1.0)}.to raise_error ArgumentError
          expect{BBox.new(1.0,1.0,1.0,nil)}.to raise_error ArgumentError
        end

      end

      context "when all parameters are not nil" do

        it "should return the correct object" do
          bbox = BBox.new(1.0,2.0,3.0,4.0)
          bbox.latmin.should == 1.0
          bbox.latmax.should == 3.0
          bbox.lonmin.should == 2.0
          bbox.lonmax.should == 4.0
        end

      end

    end

    describe "to_s" do

      it "should return a string in the format needed by opencellid" do
        bbox = BBox.new(1.0,2.0,3.0,4.0)
        expected_string = "1.0,2.0,3.0,4.0"
        bbox.to_s.should == expected_string
      end

    end

  end

end