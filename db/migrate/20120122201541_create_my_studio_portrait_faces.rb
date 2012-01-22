class CreateMyStudioPortraitFaces < ActiveRecord::Migration
  def change
    create_table :my_studio_portrait_faces do |t|
      t.references :portrait
      t.decimal :center_x
      t.decimal :center_y
      t.decimal :width
      t.decimal :height
      t.decimal :eye_left_x
      t.decimal :eye_left_y
      t.decimal :eye_right_x
      t.decimal :eye_right_y
      t.decimal :mouth_left_x
      t.decimal :mouth_left_y
      t.decimal :mouth_center_x
      t.decimal :mouth_center_y
      t.decimal :mouth_right_x
      t.decimal :mouth_right_y
      t.decimal :nose_x
      t.decimal :nose_y
      t.decimal :ear_left_x
      t.decimal :ear_left_y
      t.decimal :ear_right_x
      t.decimal :ear_right_y
      t.decimal :chin_x
      t.decimal :chin_y
      t.decimal :yaw
      t.decimal :roll
      t.decimal :pitch
      t.text :tag_attributes

      t.timestamps
    end
    add_index :my_studio_portrait_faces, :portrait_id
  end
end
