require 'spec_helper'

describe Spree::OrdersController do

	before do
		@products = []

		3.times do
			@products << FactoryGirl.create(:product)
		end

		@sale_variant = @products.sample.master
		@sale_variant.sale_price = @sale_variant.price - 1.0
		@sale_variant.save!

		@user = FactoryGirl.create(:user)
		@user.stub :has_role? => true
	  controller.stub :current_user => @user

	  @order = @user.orders.create
	  controller.stub :current_order => @order
	end

	let(:products) { @products }
	let(:sale_variant) { @sale_variant }
	let(:order) { @order }

	describe "PUT #populate" do
		it "should use the sale_price data when adding to cart" do
			controller.current_order.line_items.length.should == 0
		  submit_params = @products.inject({}) { |h, p| h.merge!({ "#{p.master.id}" => rand(9) + 1 })}
		  spree_put :populate, :variants => submit_params
		  response.code.should == "302" # cart redirect
		  controller.current_order.line_items.count.should == 3
		  controller.current_order.line_items.detect { |v| v.variant.id == @sale_variant.id }.price.to_f.should == @sale_variant.sale_price.to_f
		end
	end

  describe "PUT #update" do
  	it "should update price when sale_price is set after initial add" do
  		non_sale_variant = products.detect { |p| !p.on_sale? }.master
  	  spree_put :populate, :variants => { "#{non_sale_variant.id}" => 1 }
  	  response.code.should == "302"
  	  order.line_items.length.should == 1
  	  order.line_items.first.price.should == non_sale_variant.price
  	  order.line_items.first.quantity.should == 1

  	  non_sale_variant.update_attributes :sale_price => non_sale_variant.price - 1.0

  	  spree_put :update, :order => { "line_items_attributes" => { "0" => { "quantity" => "1", "id" => "#{order.line_items.first.id}" } } }
  	  response.code.should == "302"
  	  order.line_items.first.price = non_sale_variant.sale_price
  	end

  	it "should update price when sale_price is removed after initial add with sale price" do
  	  spree_put :populate, :variants => { "#{sale_variant.id}" => 1 }
  	  order.reload
  	  order.line_items.first.price.to_f.should == @sale_variant.sale_price.to_f

  	  @sale_variant.update_attributes :sale_price => 0
  	  @sale_variant.on_sale?.should == false
  	  spree_put :update, :order => {"line_items_attributes" =>  { "0" => { "quantity" => "2", "id" => "#{order.line_items.first.id}" } }}
  	  response.code.should == "302" # cart redirect

  	  order.line_items.length.should == 1
  	  order.line_items.first.quantity.should == 2
  	  order.line_items.first.price.to_f.should == @sale_variant.price.to_f
  	end
  end

end