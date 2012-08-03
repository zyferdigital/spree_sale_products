class AddReductionToProducts < ActiveRecord::Migration
  def change
    # specifications for the sale price column copied from spree migration for spree_variants.price
    add_column :spree_variants, :sale_price, :decimal, precision: 8, scale: 2, null: false, :default => 0.0
  end
end