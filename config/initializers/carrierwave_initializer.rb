module CarrierWave
  module RMagick

    def store_geometry
      manipulate! do |img|
        if model
          model.send('width=', img.columns) if model.respond_to?(:width)
          model.send('height=', img.rows) if model.respond_to?(:height)
        end
        img = yield(img) if block_given?
        img
      end
    end

  end
end