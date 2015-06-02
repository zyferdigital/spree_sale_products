Deface::Override.new(
  :virtual_path => "spree/admin/variants/_form",
  :name => "add_admin_variant_sale_price",
  :insert_before => '[data-hook="price"]',
  :partial => 'spree/admin/variants/sale_price'
)
