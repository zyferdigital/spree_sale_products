Deface::Override.new(
  :virtual_path => "spree/admin/variants/_form",
  :name => "add_admin_variant_sale_price",
  :insert_bottom => "div.right",
  :text => %q{
    <p data-hook="sale_price"><%= f.label :sale_price, t(:sale_price) %><br />
    <%= f.text_field :sale_price %></p>
})