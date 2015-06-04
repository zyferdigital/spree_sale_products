Spree::Variant.class_eval do
  #attr_accessible :sale_price
  #alias_method :orig_price_in, :price_in

  def sale_price=(sale_price)
      self[:sale_price] = Spree::LocalizedNumber.parse(sale_price) if sale_price.present?
  end

  def on_sale?
    self.sale_price > 0.0
  end

  def sale_perc
    if self.sale_price > 0.0
      discount = (1 - (self.sale_price / self.price)) * 100
      discount.round
    end
  end

  #def price_in(currency, get_sale_price=true)
  #  return orig_price_in(currency) unless get_sale_price == true
  #  Spree::Price.new(:variant_id => self.id, :amount => self.sale_price, :currency => currency)
  #end
  
end
