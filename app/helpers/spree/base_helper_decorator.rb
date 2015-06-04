Spree::BaseHelper.class_eval do

  def display_sale_price(product_or_variant)
    product_or_variant.
      price_in(current_currency, true).
      display_price_including_vat_for(Spree::Zone.default_tax).
      to_html
  end
end