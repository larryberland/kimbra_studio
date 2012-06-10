class AddTaxDescriptionToPurchases < ActiveRecord::Migration

  def change
    add_column :shopping_purchases, :tax_description, :text
  end

end