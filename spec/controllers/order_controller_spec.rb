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

		@user = create(:user)
		@user.stub :has_role? => true
	  controller.stub :spree_current_user => @user
	end

	let(:products) { @products }
	let(:sale_variant) { @sale_variant }
	let(:order) { controller.current_order(create_order_if_necessary: true) }

	describe "PUT #populate" do
		it "should use the sale_price data when adding to cart" do
      order # to call current_order with correct parameters
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

  context "spree_volume_pricing" do
    before do
      @variant_cost = 20.0
    	@sale_variant.price = @variant_cost
    	@sale_variant.volume_prices.create! :amount => @sale_variant.price - 1.0, :range => '(5..10)', :discount_type => 'price'
    	@sale_variant.volume_prices.create! :amount => @sale_variant.price - 5.0, :range => '(11..20)', :discount_type => 'price'
    	@sale_variant.sale_price = @sale_variant.price - 3.0
    	@sale_variant.save!
    	@products.map &:reload
    end

    let(:variant_cost) { @variant_cost }

    def order_populate quantity, diff_cost
      spree_put :populate, :variants => { "#{sale_variant.id}" => quantity }
      response.code.should == "302"
      order.reload.line_items.count.should == 1
      order.line_items.first.price.to_f.should == variant_cost - diff_cost
    end

    def order_update quantity, diff_cost
      spree_put :update, :order => {"line_items_attributes" =>  { "0" => { "quantity" => quantity.to_s, "id" => "#{order.line_items.first.id}" } } }
      response.code.should == "302"
      order.reload.line_items.count.should == 1
      order.line_items.first.price.to_f.should == variant_cost - diff_cost
    end

    it "should use the sale price when not in volume price range" do
      order_populate(1, 3.0)
      # order.line_items.first.price.to_f.should == sale_variant.price - 3.0
    end

    it "should use the sale price when in a volume price range and still less than volume discount" do
      order_populate(6, 3.0)
      # order.line_items.first.price.to_f.should == sale_variant.price - 3.0
    end

    it "should not use the sale price when volume price is greater discount" do
      order_populate(11, 5.0)
      # order.line_items.first.price.to_f.should == sale_variant.price - 5.0
    end

    it "should properly toggle between difference price levels" do
      # sale
      order_populate(1, 3.0)

      # volume, but still sale
      order_update(6, 3.0)

      # volume
      order_update(11, 5.0)

      # sale
      order_update(3, 3.0)

      # no-sale
      # if you run order_update(3, 0) it wont pass this is because item prices are not updated if the quantity changes
      sale_variant.update_attributes :sale_price => 0
      sale_variant.on_sale?.should == false
      order_update(4, 0)

      # volume
      order_update(5, 1.0)

      # normal
      order_update(1, 0)
    end
  end
end