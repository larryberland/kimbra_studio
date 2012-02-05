module CarrierWave
  module RMagick

    def store_geometry
      manipulate! do |img|
        if model
          puts "store geometry #{model} #{img.columns}x#{img.rows}"
          model.send('width=', img.columns) if model.respond_to?(:width)
          model.send('height=', img.rows) if model.respond_to?(:height)
        end
        img = yield(img) if block_given?
        img
      end
    end

    # convert portrait into a stock_image
    def store_stock
      manipulate! do |img|
        if model
          puts "store_stock"
          new_image = model.send(:process_stock, img)
          puts "store stock portrait #{model} #{img.columns}x#{img.rows}"
          puts "store stock new_image #{model} #{new_image.columns}x#{new_image.rows}"
          model.send('width=', new_image.columns) if model.respond_to?(:width)
          model.send('height=', new_image.rows) if model.respond_to?(:height)
          img = new_image
        end
        img = yield(img) if block_given?
        img
      end
    end

    #noinspection RubyArgCount
    def center_in_area
      manipulate! do |img|
        w = img.columns
        h = img.rows
        if model
          dest_width, dest_height = model.send(:get_dest_area)
          x = (dest_width - w) / 2 if w < dest_width
          y = (dest_height - h) / 2 if h < dest_height
          if x or y
            x         ||= 0
            y         ||= 0
            img = Magick::Image.new(dest_width, dest_height).composite(img, x, y, Magick::AtopCompositeOp)
          end
        end
        img = yield(img) if block_given?
        img
      end
    end

    # process the custom_part
    def store_custom_part
      manipulate! do |img|
        if model
          img = model.send(:process_custom_part, img)
        end
        img = yield(img) if block_given?
        img
      end
    end
  end
end