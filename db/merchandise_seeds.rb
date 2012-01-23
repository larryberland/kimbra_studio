class MerchandiseSeeds

  def self.seeds(seed_path)
    file_to_load = seed_path.join('pieces.yml').to_s
    image_path   = Rails.root.join('public', 'kimbra')
    info         = YAML::load(File.open(file_to_load))
    pieces_list  = info[:pieces]
    default      = info[:default]
    image_stub   = Rails.root.join('app', 'assets', 'images', 'home.png')

    puts "storing #{pieces_list.size} Pieces"
    pieces_list.each do |piece|
      parts = piece.delete(:parts)

      path = image_path.join(piece['category'].underscore.gsub(' ', '_'))
      path.mkpath unless path.directory?

      puts "piece=>#{piece['name']}"
      p = Admin::Merchandise::Piece.find_or_create_by_category_and_name(piece['category'], piece['name'])

      piece_image_fname = piece.delete('image')
      if piece_image_fname
        fname = path.join(piece_image_fname)
        if File.exist?(fname.to_s)
          p.image.store!(File.open(fname.to_s))
        else
          puts "missing Piece image fname=>#{piece_image_fname} in #{piece['category']}/#{piece['name']} image=>#{fname}"
        end
      else
        # look for an image
        fname = piece['name'].underscore.gsub(' ', '_')
        ['jpeg', 'png'].each do |ext|
          if File.exists?(path.join("#{fname}.#{ext}").to_s)
            p.image.store!(File.open(path.join("#{fname}.#{ext}").to_s))
          end
        end
        if p.image_url.blank?
          puts "missing Piece #{fname}.[png|jpeg]  in #{piece['category']}/#{piece['name']}"
          p.image.store!(File.open(image_stub.to_s)) # stub them for now
        end
      end

      # seed the parts for this Jewelry Piece
      p.parts.destroy_all if p.parts.present?
      if parts.blank?
        parts = default[:parts]
        path  = image_path
      else
        path = path.join(piece['name'].underscore.gsub(' ', '_'))
        path.mkpath unless path.directory?
      end

      parts.each do |part_info|
        part             = part_info.clone
        part_image_fname = path.join(part.delete(:image_part))
        my_part          = Admin::Merchandise::Part.create(part)
        my_part.image_part.store!(File.open(part_image_fname.to_s))
        p.parts << my_part
      end if parts.present?

      p.update_attributes(piece)
    end

  end
end