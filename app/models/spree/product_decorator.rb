Spree::Product.class_eval do
  attr_accessible :sale_price
  delegate_belongs_to :master, :sale_price

  def on_sale?
    self.variants_including_master.inject(false) { |f, v| f || v.on_sale? }
  end
end
