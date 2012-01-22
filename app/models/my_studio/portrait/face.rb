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
      puts "tag[#{tag}]=>#{values.inspect}"
      if values.kind_of?(Hash)
        values.each do |key, value|
          puts "setting #{tag}_#{key}=#{value}"
          f.send("#{tag}_#{key}=", value) if f.respond_to?("#{tag}_#{key}")
        end
      else
        puts "setting #{tag}=#{values}"
        f.send("#{tag}=", values) if f.respond_to?(tag)
      end
    end
    f.save
    f
  end
end
