class AddStripeAmountToShoppingPurchases < ActiveRecord::Migration
  def self.up
    add_column :shopping_purchases, :invoice_amount, :integer, default: 0
    add_column :shopping_purchases, :paid_amount, :integer, default: 0

    add_column :shopping_carts, :tax_description, :text
    add_column :shopping_carts, :invoice_items_amount, :integer, default: 0
    add_column :shopping_carts, :invoice_tax_amount, :integer, default: 0
    add_column :shopping_carts, :invoice_amount, :integer, default: 0
    add_column :shopping_carts, :commission_amount, :integer, default: 0

    remove_column :shopping_purchases, :total
    remove_column :shopping_purchases, :tax
    remove_column :shopping_purchases, :tax_description

    rename_column :shopping_shippings, :total_cents, :amount
    rename_column :shopping_shippings, :shipping_option, :shipping_option_name
    change_column :shopping_shippings, :amount, :integer, default: 0
  end

  def self.down
    add_column :shopping_purchases, :total, :decimal
    add_column :shopping_purchases, :tax, :decimal
    add_column :shopping_purchases, :tax_description, :text

    remove_column :shopping_purchases, :invoice_amount
    remove_column :shopping_purchases, :paid_amount

    remove_column :shopping_carts, :tax_description
    remove_column :shopping_carts, :invoice_items_amount
    remove_column :shopping_carts, :invoice_tax_amount
    remove_column :shopping_carts, :invoice_amount
    remove_column :shopping_carts, :commission_amount

    rename_column :shopping_shippings, :amount, :total_cents
    rename_column :shopping_shippings, :shipping_option_name, :shipping_option
  end
end
