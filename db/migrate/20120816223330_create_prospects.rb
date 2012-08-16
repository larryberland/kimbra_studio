class CreateProspects < ActiveRecord::Migration

  def change
    create_table :prospects, force:true do |t|
      t.string :email
      t.timestamps
    end
  end

end