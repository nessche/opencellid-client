require 'spec_helper'
require 'opencellid'

module Opencellid

  describe Response do

    describe "from_xml" do

      context "when passed nil" do

        it "should raise error" do
          expect{Response.from_xml(nil)}.to raise_error RuntimeError
        end

      end

      context "when passing a document not containing a valid root element" do

        it "should raise a RuntimeError" do
          expect{Response.from_xml("<a>This is not a valid response</a>")}.to raise_error RuntimeError
        end

      end

      context "when passing a valid measure list" do

        before do
          @response = Response.from_xml data_file_as_string("measure_list.xml")
        end

        it "should contain measures" do
          @response.should be_a Response
          @response.measures.count.should == 2
          @response.measures[0].lat.should == 60.5
        end

        it "should be an_ok response" do
          @response.should be_ok
          @response.should_not be_failed
        end

        it "should not have an error" do
           @response.error.should be_nil
        end

        it "should not contain cell sub-elements" do
          @response.cells.should be_empty
        end

      end

      context "when passing a valid response" do

        context "and response has ok status" do

          before do
            @response = Response.from_xml data_file_as_string("one_cell.xml")
          end

          it "should be an ok response" do
            @response.should be_ok
          end

          it "should contain the cell sub-elements" do
            @response.cells.count.should == 1
            @response.cells[0].id.should == 118135
          end

          it "should not have an error" do
            @response.error.should be_nil
          end

          it "should not contain measures" do
            @response.measures.should be_empty
          end

        end

        context "and response has a failure status" do

          before do
            @response = Response.from_xml data_file_as_string("cell_not_found.xml")
          end

          it "should be a failed response" do
            @response.should_not be_ok
            @response.should be_failed
          end

          it "should not contain cell sub-elements" do
            @response.cells.should be_empty
          end

          it "should not contain measures" do
             @response.measures.should be_empty
           end

          it "should have the correct error" do
            @response.error.should_not be_nil
            @response.error.code.should == 1
          end

        end

        context "and response contains a result field" do

          before do
            @response = Response.from_xml data_file_as_string("measure_added.xml")
          end

          it "should have a result" do
            @response.result.should match /^Measure added/
          end

          it "should have a cell id" do
            @response.cell_id.should == 1252312
          end

          it "should have a measure_id" do
           @response.measure_id.should == 56216401
          end

        end

      end

    end

  end



end