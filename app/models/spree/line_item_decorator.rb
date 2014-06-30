Spree::LineItem.class_eval do
  # pattern grabbed from: http://stackoverflow.com/questions/4470108/

  # the idea here is compatibility with spree_volume_prices
  # trying to create a 'calculation stack' wherein the best valid price is
  # chosen for the product. This is mainly for compatibility with spree_volume_pricing

  # https://github.com/spree/spree/blob/1-3-stable/core/app/models/spree/line_item.rb#L26
  old_copy_price = instance_method(:copy_price)
  define_method(:copy_price) do
    old_copy_price.bind(self).()

    if variant
      if self.variant.on_sale?
        discount_price = self.variant.sale_price

        if self.variant.respond_to?(:volume_price)
          volume_price = self.variant.volume_price(self.quantity)

          if discount_price < volume_price
            discount_price = volume_price
          end
        end

        self.price = discount_price
      end
    end
  end

end
