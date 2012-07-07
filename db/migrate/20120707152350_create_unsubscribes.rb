class CreateUnsubscribes < ActiveRecord::Migration

  def up
    create_table :unsubscribes, :force => true do |t|
      t.string :email
      t.timestamps
    end
    add_index :unsubscribes, :email
  end

  def down
    drop_table :unsubscribes
  end

end