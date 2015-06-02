Deface::Override.new(
  :virtual_path => "spree/admin/variants/_form",
  :name => "add_admin_variant_sale_price",
  :insert_before => "[data-hook='price'],
  :text => %q{
  <div class="form-group" data-hook="sale_price">
    <%= f.label :sale_price, Spree.t(:sale_price) %>
    <%= f.text_field :sale_price, :value => number_to_currency(@variant.sale_price, :unit => ''), :class => 'form-control' %>
  </div>
})
