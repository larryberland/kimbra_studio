require Rails.root.join('lib','k_magick.rb').to_s
class ActiveRecord::Base
  include KMagick
end