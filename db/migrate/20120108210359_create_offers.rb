class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :image
      t.references :pieces
      t.timestamps
    end
  end
end
