Deface::Override.new(
  :virtual_path => "spree/admin/products/_form",
  :name => "add_admin_sale_price",
  :insert_top => "[data-hook='admin_product_form_right'], #admin_product_form_right[data-hook]",
  :sequence => 10,
  :text => %q{
  <%= f.field_container :sale_price do %>
    <%= f.label :sale_price, t(:sale_price) %><br/>
    <%= f.text_field :sale_price %>
    <%= f.error_message_on :sale_price %>
  <% end %>
})
