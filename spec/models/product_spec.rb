require 'spec_helper'

describe Spree::Product do
  before do
    @product = FactoryGirl.create :product
  end

  let(:product) { @product }

  it "should only be marked as on sale if a > 0 number is in place" do
    product.on_sale?.should == false
    product.update_attributes :sale_price => 5.0
    product.reload.master.on_sale?.should == true
    product.on_sale?.should == true
    product.update_attributes :sale_price => 0.0
    product.reload.on_sale?.should == false
  end
end