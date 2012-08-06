Spree::LineItem.class_eval do
  # pattern grabbed from: http://stackoverflow.com/questions/4470108/

  # the idea here is compatibility with spree_volume_prices
  # trying to create a 'calculation stack' wherein the best valid price is
  # chosen for the product. This is mainly for compatibility with spree_volume_pricing

  old_copy_price = instance_method(:copy_price)
  define_method(:copy_price) do
    new_price = old_copy_price.bind(self).()

    if self.variant.on_sale?
      sale_price = self.variant.sale_price

      if (!new_price.nil? and sale_price <= new_price) or sale_price <= self.price
        return self.price = sale_price
      end
    end

    if new_price.nil?
      self.price = self.variant.price
    else
      self.price = new_price
    end
  end
end