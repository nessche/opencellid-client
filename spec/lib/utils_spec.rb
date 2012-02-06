require 'spec_helper'
require 'opencellid'

module Opencellid

  describe "to_i_or_nil" do

    context "when passed nil" do

      it "should return nil" do
        ::Opencellid.to_i_or_nil(nil).should be_nil
      end

    end

    context "when passed an empty string" do

      it "should return nil" do
        ::Opencellid.to_i_or_nil("").should be_nil
      end

    end

    context "when passed a non-empty string" do

      it "should invoke to_i on the string and return the result" do
        string = double(:length => 1)
        string.should_receive(:to_i).and_return 5
        ::Opencellid.to_i_or_nil(string).should == 5
      end

    end

  end

  describe "to_f_or_nil" do

     context "when passed nil" do

       it "should return nil" do
         ::Opencellid.to_f_or_nil(nil).should be_nil
       end

     end

     context "when passed an empty string" do

       it "should return nil" do
         ::Opencellid.to_f_or_nil("").should be_nil
       end

     end

     context "when passed a non-empty string" do

       it "should invoke to_f on the string and return the result" do
         string = double(:length => 1)
         string.should_receive(:to_f).and_return 5.567
         ::Opencellid.to_f_or_nil(string).should == 5.567
       end

     end

  end

  describe "to_datetime_or_nil" do

     context "when passed nil" do

       it "should return nil" do
         ::Opencellid.to_datetime_or_nil(nil,"format").should be_nil
       end

     end

     context "when passed an empty string" do

       it "should return nil" do
         ::Opencellid.to_datetime_or_nil("","format").should be_nil
       end

     end

     context "when passed a non-empty string" do

       it "should invoke strptime on the DateTime and return the result" do
         now = DateTime.now
         string = double(:length => 1)
         DateTime.should_receive(:strptime).with(string,"format").and_return(now)
         ::Opencellid.to_datetime_or_nil(string,"format").should == now
       end

     end

   end


end