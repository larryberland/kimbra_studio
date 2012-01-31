class MyStudio::Portrait::Face < ActiveRecord::Base
  attr_accessible :width
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'

  before_save :to_coords

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

  def calculate_area


  end

  def left
    a = []
    a << eye_left_x if eye_left_x.present?
    a << eye_right_x if eye_right_x.present?
    a << mouth_left_x if mouth_left_x.present?
    a << mouth_center_x if mouth_center_x.present?
    a << mouth_right_x if mouth_right_x.present?
    a << nose_x if nose_x.present?
    a << ear_left_x if ear_left_x.present?
    a << ear_right_x if ear_right_x.present?
    a << chin_x if chin_x.present?
    return a.min, a.max
  end

  def top
    a = []
    a << eye_left_y if eye_left_y.present?
    a << eye_right_y if eye_right_y.present?
    a << mouth_left_y if mouth_left_y.present?
    a << mouth_center_y if mouth_center_y.present?
    a << mouth_right_y if mouth_right_y.present?
    a << nose_y if nose_y.present?
    a << ear_left_y if ear_left_y.present?
    a << ear_right_y if ear_right_y.present?
    a << chin_y if chin_y.present?
    return a.min, a.max
  end

  def center_me(item)
    part  = item.part
    dx    = (part.item_width - face_width) * 0.50
    dy    = (part.item_height - face_height) * 0.50
    new_x = [face_top_left_x - dx.to_i, 0].max
    new_y = [face_top_left_y - dy.to_i, 0].max

    puts "crop #{new_x} #{new_y} #{part.item_width}x#{part.item_height}"
    img     = Magick::Image.read(portrait.image_url(:face)).first

    # crop the portrait for the kimbra part
    cropped = img.crop(new_x, new_y, part.item_width, part.item_height)
    dump_cropped(cropped, part.item_width, part.item_height)

    t_assembled = Tempfile.new(['assemble', '.jpg'])
    image_piece = Magick::Image.read(part.image_part_url).first
    image_piece.composite(cropped, part.item_x, part.item_y, Magick::AtopCompositeOp).write(t_assembled.path)
    dump_assembled(image_piece)
    item.image_item.store!(File.open(t_assembled.path))
    item.write_image_item_identifier
    item.save
    item
  end

  def inspect_f
    puts "top= x=>#{face_top_left_x} y=>#{face_top_left_y} width=>#{face_width} height=>#{face_height}"
  end

  def center_in_size(layout, padding=0.38)
    center_in_area(layout.w, layout.h, padding)
  end

  def center_in_area(dest_width, dest_height, padding=0.38)

    puts "orig x=>#{face_top_left_x} y=#{face_top_left_y} size=>#{face_width}x#{face_height}"
    # add 38% to face width and height
    w     = (face_width / padding).to_i
    h     = (face_height / padding).to_i
    new_x = face_top_left_x - ((w - face_width)/2)
    new_y = face_top_left_y - ((h - face_height)/2)
    puts "38%  x=>#{new_x} y=#{new_y} size=>#{w}x#{h}"

    #my_portrait.crop(new_x, new_y, w, h).write("#{id}_first.jpg")

    # place new area into destination width x height
    if w < dest_width
      # center in destination
      dx    = (dest_width - w) * 0.50
      new_x = [(new_x - dx).to_i, 0].max
      w     = dest_width
      puts "center width"
    else
      puts "resize width"
      resize = true
    end
    if h < dest_height
      # center in destination
      dy    = (dest_height - h) * 0.50
      new_y = [(new_y - dy).to_i, 0].max
      h     = dest_height
      puts "center height"
    else
      resize = true
      puts "resize height"
    end

    puts "face_id=>#{id} dest=>#{dest_width}x#{dest_height} dx=>#{dx} dy=>#{dy}"
    puts "center in dest x=>#{new_x} y=>#{new_y} size=>#{w}x#{h}"
    img        = image_new(dest_width, dest_height)

    # calculate crop area so resize will not clip image
    new_width  = w
    new_height = (dest_height.to_f * w.to_f) / dest_width.to_f
    if new_height < dest_height
      new_width = (dest_height.to_f * new_height) / dest_width.to_f
    end
    if new_width > w
      new_x = new_x - ((new_width - w) / 2)
    elsif new_width < w
      new_x = new_x + ((w - new_width) / 2)
    end
    if new_height > h
      new_y = new_y - ((new_height - h) / 2)
    elsif new_height < h
      new_y = new_y + ((h - new_height) / 2)
    end

    #puts "crop size old=>#{w}x#{h} new=>#{new_width}x#{new_height}"
    #puts "crop left   x=>#{new_x}    y=>#{new_y}"

    # crop the portrait to the destination size
    cropped = my_portrait.crop(new_x, new_y, new_width.to_i, new_height.to_i)
    cropped = cropped.resize_to_fit(dest_width, dest_height) if resize

    # return the cropped image into our destination image
    img.composite(cropped, 0, 0, Magick::AtopCompositeOp)
  end

  def cropped(portrait_image=nil)
    portrait_image ||= my_portrait
    portrait_image.crop(face_top_left_x, face_top_left_y, face_width, face_height)
  end

  # blank image the width and height of know face area
  def area
    image_new(face_width, face_height)
  end

  def area_in_portrait
    my_portrait.composite(area, face_top_left_x, face_top_left_y, Magick::AtopCompositeOp)
  end

  private

  def my_portrait
    @my_portrait ||= Magick::Image.read(portrait.image_url(:face)).first
    raise "no portrait for face=>#{inspect}" unless @my_portrait.kind_of?(Magick::Image)
    @my_portrait
  end

  # calculate face coordinates
  def to_coords
    y_top, y_bottom = top
    x_left, x_right = left
    # grab the portrait 900x900 version
    if portrait and portrait.image_url
      img                  = my_portrait
      self.face_top_left_x = (img.columns * x_left) / 100.0
      self.face_top_left_y = (img.rows * y_top) / 100.0
      self.face_width      = (img.columns * x_right)/100.0 - face_top_left_x
      self.face_height     = (img.rows * y_bottom)/100.0 - face_top_left_y
    end
  end

  def dump_filename
    "face_#{id}_portrait_#{portrait.id}.jpg"
  end

  def dump_cropped(img, width, height)
    dump('cropped', img, "face_#{id}_portrait_#{portrait.id}_size_#{width}_x_#{height}.jpg")
  end

  def dump_assembled(img)
    dump('assembled', img)
  end

end
