require 'opencellid'

module Opencellid

  describe Opencellid do

    describe "get" do

      before do
        @oci = Opencellid.new
      end

      it "should return a response object" do
        @oci.get(cellid: 118135, mnc: 91, mcc: 244).should be_a Response
      end

      context "when the response is successful" do

        it "should contain a cell object" do
          resp = @oci.get(cellid: 118135, mnc: 91, mcc: 244)
          resp.should be_a Response
          resp.should be_ok
          resp.cell.should be_a Cell
          cell = resp.cell
          cell.id.should == 118135
        end

      end

      context "when no mnc or mcc is passed" do

        it "should return a cell not found response" do
          resp = @oci.get(cellid: 22)
          resp.should be_failed
          error = resp.error
          error.should be_a Error
          error.code.should == 1

        end

      end

    end

  end

end