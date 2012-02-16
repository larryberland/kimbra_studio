class CreateStoreCredits < ActiveRecord::Migration
  def change
    create_table :store_credits do |t|
      t.decimal :amount, :default => 0.0
      t.references :user

      t.timestamps
    end
    add_index :store_credits, :user_id
  end
end
