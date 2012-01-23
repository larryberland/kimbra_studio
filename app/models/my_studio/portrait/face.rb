class MyStudio::Portrait::Face < ActiveRecord::Base
  attr_accessible :width
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'

  def self.from_tag(face_tag)
    f = MyStudio::Portrait::Face.new
    #f.width = face_tag["width"]
    #f.height = face_tag["height"],
    #"center"=>{"x"=>66.89, "y"=>42.44},
    #"eye_left"=>{"x"=>65.35, "y"=>40.74},
    #"eye_right"=>{"x"=>68.14, "y"=>40.28},
    #"mouth_left"=>{"x"=>65.7, "y"=>44.53},
    #"mouth_center"=>{"x"=>67, "y"=>44.8},
    #"mouth_right"=>{"x"=>68.4, "y"=>44.15},
    #"nose"=>{"x"=>66.83, "y"=>43.16},
    #"ear_left"=>nil,
    #"ear_right"=>nil,
    #"chin"=>nil,
    #"yaw"=>-2.01,
    #"roll"=>-6.99,
    #"pitch"=>-5.28,
    face_tag.each do |tag, values|
      if values.kind_of?(Hash)
        values.each do |key, value|
          f.send("#{tag}_#{key}=", value) if f.respond_to?("#{tag}_#{key}")
        end
      else
        f.send("#{tag}=", values) if f.respond_to?(tag)
      end
    end
    f.save
    f
  end

  def center_me(item)
    part = item.part
    dx = (part.item_width - face_width) * 0.50
    dy = (part.item_height - face_height) * 0.50
    new_x = [face_top_left_x - dx.to_i, 0].max
    new_y = [face_top_left_y - dy.to_i, 0].max

    puts "crop #{new_x} #{new_y} #{part.item_width}x#{part.item_height}"
    img = Magick::Image.read(portrait.image_url(:face)).first
    cropped = img.crop(new_x, new_y, part.item_width, part.item_height) #img.crop(x, y, width, height) -> image
    t_crop = Tempfile.new(['crop', '.jpeg'])
    cropped.write("crop.jpeg")
    puts "crop=>#{t_crop.path}"

    t_assembled = Tempfile.new(['assemble', '.jpeg'])
    image_piece = Magick::Image.read(part.image_part_url).first
    image_piece.composite(cropped, part.item_x, part.item_y, Magick::AtopCompositeOp).write("assembled.jpeg")
    puts "image_piece=>#{t_assembled.path}"

    item.image_item.store!(File.open('assembled.jpeg'))
    item.write_image_item_identifier
    item.save
    item
  end

  def inspect_f
    puts "top= x=>#{face_top_left_x} y=>#{face_top_left_y} width=>#{face_width} height=>#{face_height}"
  end
end
