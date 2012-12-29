class AddColumnToPartLayouts < ActiveRecord::Migration
  def change
    add_column :part_layouts, :operator, :string
    add_column :piece_layouts, :operator, :string
  end
end
