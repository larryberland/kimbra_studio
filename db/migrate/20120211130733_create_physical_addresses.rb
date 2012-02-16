class CreatePhysicalAddresses < ActiveRecord::Migration
  def change
    create_table :physical_addresses do |t|

      t.timestamps
    end
  end
end
