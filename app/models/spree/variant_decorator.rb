Spree::Variant.class_eval do
  #attr_accessible :sale_price

  def on_sale?
    sale_price > 0.0
  end

  def sale_perc
    if sale_price > 0.0
      discount = (1 - (self.sale_price / self.price)) * 100
      discount.round
    end
  end 
  
end
