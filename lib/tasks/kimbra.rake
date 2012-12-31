namespace 'kimbra' do

  desc "Seed the new Kimbra Komposite Images for Offers"
  task :seed_kkp => :environment do
    data = [
        {category: 'Photo Bracelets', name: 'Alexis Bracelet', image: 'alexis_bracelet.png',
         layouts:  [
                       {x: 108, y: 48, w: 70, h: 83},
                       {x: 227, y: 48, w: 70, h: 81},
                       {x: 344, y: 48, w: 70, h: 81},
                       {x: 463, y: 48, w: 69, h: 82},
                   ]},
        {category:     'Photo Bracelets', name: 'Eileen Bracelet', image: 'eileen_bracelet.png',
         layouts:      [
                           {x: 88, y: 138, w: 98, h: 72, degrees: 136.0},
                           {x: 112, y: 205, w: 72, h: 72, degrees: 90.0},
                           {x: 128, y: 313, w: 98, h: 71, degrees: 56.09},
                           {x: 153, y: 423, w: 68, h: 68, degrees: 0.0},
                           {x: 276, y: 431, w: 102, h: 66, degrees: -5.9},
                           {x: 388, y: 399, w: 68, h: 68, degrees: -49.6},
                           {x: 431, y: 307, w: 96, h: 72, degrees: -78.08},
                           {x: 440, y: 109, w: 66, h: 66, degrees: 228.34},
                       ],
         part_layouts: [
                           {x: 41, y: 23, w: 182, h: 132},
                           {x: 60, y: 32, w: 125, h: 138},
                           {x: 41, y: 23, w: 182, h: 132},
                           {x: 60, y: 32, w: 125, h: 138},
                           {x: 41, y: 23, w: 182, h: 132},
                           {x: 60, y: 32, w: 125, h: 138},
                           {x: 41, y: 23, w: 182, h: 132},
                           {x: 60, y: 32, w: 125, h: 138},
                       ]},

    #{category: 'Photo Necklaces', name: 'Awareness Necklace', image: 'awareness_necklace.png', layout: {x: 92, y: 106, w: 62, h: 59}},
    #{category: 'Photo Necklaces', name: 'Sophie Necklace', image: 'sophie_necklace.png', layout: {x: 77, y: 83, w: 42, h: 47}},
    #{category: 'Photo Necklaces', name: 'Bailey Necklace', image: 'bailey_necklace.png', layout: {x: 63, y: 62, w: 61, h: 113}},
    #{category: 'Photo Necklaces', name: 'Denise Pendant', image: 'denise_pendant.png', layout: {x: 84, y: 92, w: 39, h: 60}},
    #{category: 'Photo Necklaces', name: 'Embrace Necklace', image: 'embrace_necklace.png', layout: {x: 133, y: 275, w: 91, h: 140}},
    #{category: 'Photo Necklaces', name: 'Linda Pendant', image: 'linda_pendant.png', layout: {x: 56, y: 70, w: 72, h: 109}},
    #{category: 'Photo Necklaces', name: 'Madelyn Necklace', image: 'madelyn_necklace.png', layout: {x: 220, y: 381, w: 151, h: 143}},
    #{category: 'Photo Necklaces', name: 'My Love Necklace', image: 'my_love_necklace.png', layout: {x: 89, y: 83, w: 41, h: 63}},
    #{category: 'Photo Necklaces', name: 'Roseanne Pendant', image: 'roseanne_pendant.png', layout: {x: 41, y: 96, w: 123, h: 83}},
    #{category: 'Photo Charms', name: 'Annika Charm', image: 'annika_charm.png', layout: {x: 22, y: 34, w: 151, h: 151}},
    #{category: 'Photo Charms', name: 'Evalina Charm', image: 'evalina_charm.png', layout: {x: 65, y: 77, w: 69, h: 69}},
    #{category: 'Photo Charms', name: 'Harper Charm', image: 'harper_charm.png', layout: {x: 22, y: 49, w: 154, h: 106}},
    #{category: 'Photo Charms', name: 'Harper Charm (two sided)', image: 'harper_charm_two_sided.png', layout: {x: 19, y: 48, w: 161, h: 111}},
    #{category: 'Photo Charms', name: 'Karrie Charm', image: 'karrie_charm.png', layout: {x: 53, y: 67, w: 100, h: 76}},
    #{category: 'Photo Charms', name: 'Kayda Charm', image: 'kayda_charm.png', layout: {x: 35, y: 53, w: 123, h: 120}},
    #{category: 'Photo Charms', name: 'Margaret Charm', image: 'margaret_charm.png', layout: {x: 31, y: 33, w: 137, h: 152}},
    #{category: 'Photo Charms', name: 'Nicole Charm', image: 'nicole_charm.png', layout: {x: 61, y: 62, w: 75, h: 94}},
    #{category: 'Photo Charms', name: 'Rachel Charm', image: 'rachel_charm.png', layout: {x: 53, y: 64, w: 94, h: 94}},
    #{category: 'Photo Charms', name: 'Rachel Charm (two sided)', image: 'rachel_charm_two_sided.png', layout: {x: 53, y: 67, w: 89, h: 89}},
    #{category: 'Photo Charms', name: 'Sadie Charm', image: 'sadie_charm.png', layout: {x: 67, y: 26, w: 72, h: 158}},
    #{category: 'Photo Charms', name: 'Sela Charm', image: 'sela_charm.png', layout: {x: 50, y: 35, w: 101, h: 147}},
    #{category: 'Photo Charms', name: 'Sela Charm (two sided)', image: 'sela_charm_two_sided.png', layout: {x: 49, y: 36, w: 106, h: 153}},
    #{category: 'Photo Charms', name: 'Shelise Charm', image: 'shelise_charm.png', layout: {x: 50, y: 62, w: 97, h: 97}},
    #{category: 'Photo Charms', name: 'Taneka Charm', image: 'taneka_charm.png', layout: {x: 64, y: 48, w: 74, h: 112}},
    #{category: 'Photo Charms', name: 'Tucker Charm', image: 'tucker_charm.png', layout: {x: 62, y: 55, w: 72, h: 78}},
    #{category: 'Photo Charms', name: 'Wendy Bead Charm', image: 'wendy_bead_charm.png', layout: {x: 81, y: 110, w: 36, h: 49}},
    #{category: 'Photo Charms', name: 'Baby Foot Bead Charm', image: 'baby_foot_bead_charm.png', layout: {x: 78, y: 107, w: 39, h: 51}},
    #{category: 'Photo Charms', name: 'Paw Print Bead Charm', image: 'paw_print_bead_charm.png', layout: {x: 78, y: 108, w: 39, h: 47}},
    #{category: 'Photo Holiday', name: 'Aspen Ornament', image: 'aspen_ornament.png', layout: {x: 81, y: 95, w: 43, h: 43}},
    #{category: 'Photo Holiday', name: 'Awareness Ornament', image: 'awareness_ornament.png', layout: {x: 60, y: 42, w: 75, h: 99}},
    #{category: 'Photo Holiday', name: 'Evergreen Ornament', image: 'evergreen_ornament.png', layout: {x: 77, y: 101, w: 47, h: 47}},
    #{category: 'Photo Holiday', name: 'Fairchild Ornament', image: 'fairchild_ornament.png', layout: {x: 63, y: 91, w: 77, h: 77}},
    #{category: 'Photo Holiday', name: 'Joy Love Peace Ornament', image: 'joy_love_peace_ornament.png', layout: {x: 59, y: 90, w: 83, h: 83}},
    #{category: 'Photo Holiday', name: 'Keepsake Year Frame', image: 'keepsake_year_frame.png', layout: {x: 67, y: 60, w: 66, h: 86}},
    #{category: 'Photo Holiday', name: 'Keepsake Year Frame (horizontal)', image: 'keepsake_year_frame_horizontal.png', layout: {x: 61, y: 73, w: 86, h: 66}},
    #{category: 'Photo Holiday', name: 'Memorial Ornament', image: 'memorial_ornament.png', layout: {x: 60, y: 72, w: 81, h: 113}}
    ]
    data.each do |options|
      p = Admin::Merchandise::Piece.find_by_category_and_name(options[:category], options[:name])
      raise "didn't find piece #{options.inspect}" if p.nil?

      if (options[:layout])
        layout = p.parts.first.piece_layout.layout
        unless layout.update_attributes(options[:layout])
          raise "unable to set layout for #{options.inspect}"
        end
      elsif (options[:layouts])
        # update all the parts piece_layout information
        p.parts.each do |part|
          if layout = options[:layouts][part.order]
            unless part.piece_layout.layout.update_attributes(layout)
              raise "unable to set piece layout for #{options.inspect}"
            end
          end
          if options[:part_layouts]
            if layout = options[:part_layouts][part.order]
              unless part.part_layout.layout.update_attributes(layout)
                raise "unable to set part layout for #{options.inspect}"
              end
              fname = Rails.root.join("public", 'kimbra', options[:category], options[:name], "part#{part.order}.png").to_s.gsub(' ', '_').downcase
              if File.exist?(fname)
                part.image_part.store!(File.open(fname))
                part.save
              else
                puts "NO file:#{fname}"
              end
            end
          end

        end
      end

      unless p.update_attributes(custom_layout: 'composite', photo: true)
        raise "error on update #{p.errors.full_messages}"
      end

      fname = Rails.root.join("public", 'kimbra', options[:category], options[:image]).to_s.gsub(' ', '_').downcase
      if File.exist?(fname)
        p.image.store!(File.open(fname))
      else
        puts "missing Piece image fname=>#{fname} in #{options[:category]}"
      end
      p.save
      Admin::Merchandise::Piece.fog_buster(p.id)
      # convert any current Offer.custom_layouts into composite
      Admin::Customer::Offer.find_all_by_piece_id(p.id).each do |offer|
        offer.update_attributes(custom_layout: 'composite')
      end
      puts "updated #{options[:name]}"
    end

    data = [
        {category: 'Photo Bracelets', name: 'Leota Bracelet',
         image:    'leota_bracelet.png',
         price:    180.00,
         layouts:  [
                       {x: 159, y: 426, w: 98, h: 98, degrees: 75.66},
                       {x: 250, y: 600, w: 98, h: 98, degrees: 29.74},
                       {x: 432, y: 652, w: 98, h: 98, degrees: -21.25},
                       {x: 599, y: 553, w: 98, h: 98, degrees: -67.1}]
        }
    ]
    data.each do |options|
      p = Admin::Merchandise::Piece.find_by_category_and_name(options[:category], options[:name])
      raise "didn't find piece #{options.inspect}" if p.nil?

      options[:layouts].each_with_index do |piece_layout, index|
        layout = p.parts[index].piece_layout.layout
        unless layout.update_attributes(piece_layout)
          raise "unable to set layout for parts[#{index}], layout=>#{piece_layout.inspect}"
        end
      end

      if (options[:price])
        p.price = options[:price]
      end

      unless p.update_attributes(custom_layout: 'composite', photo: true)
        raise "error on update #{p.errors.full_messages}"
      end

      fname = Rails.root.join("public", 'kimbra', options[:category], options[:image]).to_s.gsub(' ', '_').downcase
      if File.exist?(fname)
        p.image.store!(File.open(fname))
      else
        p4
        puts "missing Piece image fname=>#{fname} in #{options[:category]}"
      end

      p.save
      Admin::Merchandise::Piece.fog_buster(p.id)

      # convert any current Offer.custom_layouts into composite
      Admin::Customer::Offer.find_all_by_piece_id(p.id).each do |offer|
        offer.update_attributes(custom_layout: 'composite')
      end
      puts "updated #{options[:name]}"
    end
    puts 'Finished.'
  end

  desc 'Add rings back in to the mix.'
  task :seed_rings => :environment do
    image_path = Rails.root.join('public', 'kimbra')
    default    = {parts:        {image_part: 'part_charm.png'},
                  part_layout:  {layout: {x: 19, y: 34, w: 90, h: 137}},
                  piece_layout: {layout: {x: 0, y: 0, w: 70, h: 85}}
    }
    data       = [
        {category:          'Photo Rings', name: 'Emma Ring', price: 98.00,
         short_description: 'Oval measuring: 1"h x 3/4"w. Available in sizes 6-9. Solid Sterling Silver. Completely waterproof.',
         image:             'emma_ring.jpeg',
         parts:             {image_part:   'part0.png',
                             order:        0,
                             part_layout:  {layout: {x: 30, y: 25, w: 213, h: 297}},
                             piece_layout: {image: 'emma_ring.png', layout: {x: 31, y: 11, w: 115, h: 160}}
         }},

        {category:          'Photo Rings', name: 'Cadence Ring', price: 98.00,
         short_description: 'Photo measuring: 9/16"w x 3/4"h. Available in sizes 6-8. Solid Sterling Silver. Completely waterproof.',
         image:             'cadence_ring.jpeg',
         parts:             {image_part:   'part0.png',
                             order:        0,
                             part_layout:  {layout: {x: 102, y: 78, w: 301, h: 372}},
                             piece_layout: {image: 'cadence_ring.png', layout: {x: 77, y: 29, w: 105, h: 129}}
         }}
    ]
    data.each do |piece|
      parts = piece.delete(:parts)
      path  = image_path.join(piece[:category].underscore.gsub(' ', '_'))
      puts "piece=>#{piece[:name]}"
      p                 = Admin::Merchandise::Piece.find_or_create_by_category_and_name(piece[:category], piece[:name])
      piece_image_fname = piece.delete(:image)
      if piece_image_fname
        fname = path.join(piece_image_fname)
        if File.exist?(fname.to_s)
          p.image.store!(File.open(fname.to_s))
        else
          puts "missing Piece image fname=>#{piece_image_fname} in #{piece['category']}/#{piece['name']} image=>#{fname}"
        end
      else
        fname = to_filename(piece[:name])
        ['jpeg', 'png'].each do |ext|
          fname_path = path.join("#{fname}.#{ext}").to_s
          if File.exists?(fname_path)
            p.image.store!(File.open(fname_path))
            break
          else
            puts "missing Piece image fname=>#{fname} for image=>#{fname_path}"
          end
        end
        if p.image_url.blank?
          puts "missing Piece #{fname}.[png|jpeg]  in #{piece['category']}/#{piece['name']}"
          p.image.store!(File.open(image_stub.to_s)) # stub them for now
        end
      end

      p.parts.destroy_all if p.parts.present?
      sub_dir  = piece[:name].gsub(' ', '_').gsub('(', '').gsub(')', '').underscore
      sub_path = path.join(sub_dir)
      sub_path.mkpath unless sub_path.directory?
      part_image_fname = sub_path.join(parts[:image_part])
      p.parts << Admin::Merchandise::Part.seed(piece, default, part_image_fname)

      layout = p.parts.first.piece_layout.layout
      unless layout.update_attributes(parts[:piece_layout][:layout])
        raise "unable to set piece_layout for #{piece.inspect}"
      end

      layout = p.parts.first.part_layout.layout
      unless layout.update_attributes(parts[:part_layout][:layout])
        raise "unable to set part_layout for #{piece.inspect}"
      end

      unless p.update_attributes(custom_layout: 'composite', photo: true)
        raise "error on update #{p.errors.full_messages}"
      end

      fname = path.join(parts[:piece_layout][:image])
      if File.exist?(fname)
        p.image.store!(File.open(fname))
      else
        puts "missing Piece image fname=>#{fname} in #{piece[:category]}"
      end

      puts p.save
      puts Admin::Merchandise::Piece.fog_buster(p.id).errors.full_messages
      puts p.update_attributes(piece)
    end
    puts 'Finished.'
  end

  desc "Seed the chains into Kimbra pieces"
  task :seed_chains => :environment do
    seed_path    = Rails.root.join('db', 'seed')
    file_to_load = seed_path.join('chains.yml').to_s
    image_path   = Rails.root.join('public', 'kimbra')
    info         = YAML::load(File.open(file_to_load))
    pieces_list  = info[:pieces]
    default      = info[:default]
    image_stub   = Rails.root.join('app', 'assets', 'images', 'kimbra_logo.png')

    # remove any current chains
    Admin::Merchandise::Piece.for_chains.destroy_all

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
      end

      p.parts.destroy_all if p.parts

      # seed the parts for this Jewelry Piece
      parts.each do |part_info|
        attrs            = part_info.clone
        part_image_fname = path.join(piece_image_fname)
        p.parts << Admin::Merchandise::Part.seed(attrs, default, part_image_fname)
      end if parts.present?

      p.update_attributes(piece)
    end

  end

  desc "Seed the photo column in Pieces table"
  task :seed_piece_photo => :environment do
    Admin::Merchandise::Piece.all.each do |p|
      have_photos = false
      p.parts.each do |part|
        if part.photo?
          have_photos = true
          break
        end
      end
      puts "#{p.name} photos:#{have_photos}"
      p.photo = have_photos
      p.save
    end
  end

  desc "Send unsent offer emails"
  task :send_offers => :environment do
    Admin::Customer::Email.send_offer_emails
  end

  desc "Seed Studios from Kimbra Spreadsheet. Use: [n] to add next n rows. Defaults to 10."
  task :seed_studio_owners, [:rows_to_add] => :environment do |t, args|
    require 'csv'
    last_row_added = User.maximum(:csv_row).to_i
    args.with_defaults rows_to_add: 10
    CSV.open('kimbra_studios.csv', "r", headers: true).each_with_index do |row, idx|
      csv_row = idx + 2
      # Skip over spreadsheet rows we already loaded.
      next unless csv_row > last_row_added
      # Only add the requested number of rows.
      break if csv_row >= last_row_added + args.rows_to_add.to_i + 1
      attrs = {address_1:           row["BADDR2"],
               address_2:           row["BADDR3"],
               phone_number:        row["PHONE1"],
               country_abbrev:      row["BADDR5"].to_s.strip.upcase,
               minisite_attributes: {bgcolor:     '#2a1907',
                                     font_color:  '#d3b492',
                                     font_family: 'Arial'},
               info_attributes:     {}}

      attrs[:name] = row["COMPANYNAME"] || row["NAME"] || row["CONT1"] || row["CONT2"]
      attrs[:name] = attrs[:name].to_s.titleize

      user_attrs = {email:      row["EMAIL"] || row["EMAIL2"],
                    address_1:  row['BADDR2'] || row['BADDR1'],
                    first_name: row["FIRSTNAME"],
                    last_name:  row["LASTNAME"],
                    joined_on:  "01/01/2012"}
      if (user_attrs[:email].present?)

        user_attrs[:email].downcase!

        user_attrs[:first_pass] = User.generate_random_text
        user_attrs[:password]   = user_attrs[:first_pass]
        user_attrs[:csv_row]    = csv_row

        if (row['JOINED'])
          on                     = row['JOINED'].strip.split('/')
          user_attrs[:joined_on] = "#{on[1]}/#{on[0]}/#{on[2]}" # d/m/year
        end

        attrs[:info_attributes][:website]         = row["WEBSITE"]
        attrs[:info_attributes][:tax_ein]         = row["TAX_ID"]
        attrs[:info_attributes][:commission_rate] = 10

        city_state_zip = row["BAADR4"].to_s.strip.upcase
        info           = city_state_zip.split(',')
        if (info.size != 2)
          puts "[#{csv_row}]city_state_zip:#{city_state_zip} url:#{row["WEBSITE"]} email:#{user_attrs[:email]}"
        end
        user_attrs[:raw_seed] = city_state_zip

        # parse city, state postal_code
        user_attrs[:city]     = info[0].strip
        state_and_zip         = info[1].strip.split(" ")
        state_name_or_abbrev  = state_and_zip.shift.strip
        user_attrs[:zip_code] = state_and_zip.join(" ").strip

        s = State.find_by_abbreviation(state_name_or_abbrev.upcase)
        s = State.find_by_name(state_name_or_abbrev.titleize) if s.nil?

        if (s.nil?)
          puts "[#{csv_row}] No State for state:#{state_name_or_abbrev} raw_seed:#{city_state_zip} url:#{row["WEBSITE"]} email:#{user_attrs[:email]}"
          next
        end
        user_attrs[:state] = s
        u                  = User.find_by_email(user_attrs[:email])
        result             = if (u.nil?)
                               u = User.new(user_attrs)
                               u.skip_confirmation!
                               u.save
                             else
                               on = user_attrs[:joined_on].to_date
                               puts ""
                               puts "[#{csv_row}] Duplicate email url:#{row["WEBSITE"]} email:#{user_attrs[:email]}"
                               puts "[#{csv_row}] prev:#{u.joined_on} row:#{u.csv_row} addr:#{u.formatted_address}"
                               puts "[#{csv_row}]  now:#{on} row:#{user_attrs[:csv_row]} addr:#{user_attrs[:raw_seed]}"
                               puts "[#{csv_row}] u:#{u.inspect}"
                               puts "[#{csv_row}] a:#{user_attrs.inspect}"
                               puts "[#{csv_row}] #{row.inspect}"


                               if u.joined_on.present? && on > u.joined_on
                                 puts "[#{csv_row}]update row"
                                 u.skip_confirmation!
                                 u.update_attributes(user_attrs)
                               else
                                 puts "[#{csv_row}]NOT updating"
                                 true
                               end
                             end
        if (result)

          # ready to create a studio for this user
          if (u.state)

            # lets create the studio
            attrs[:owner]    = u
            abbrev           = attrs.delete(:country_abbrev)
            attrs[:country]  = Country.find_by_abbreviation(abbrev)
            attrs[:state]    = u.state
            attrs[:city]     = u.city
            attrs[:zip_code] = u.zip_code

            studio = u.studio(true)
            result = if (studio.nil?)
                       studio = Studio.create(attrs)
                     else
                       studio.update_attributes(attrs)
                     end
            if (!result)
              puts "errors:#{studio.errors.full_messages}"
              puts "studio[#{csv_row}]:#{studio.inspect}"
              puts "studio[#{csv_row}]:#{row.inspect}"
            else
              puts "added [#{csv_row}] email:#{studio.owner.email} pwd:#{studio.owner.first_pass} id:#{studio.id} #{studio.name} "
            end
          else
            puts "fix_me"
            puts "NO State for user [#{csv_row}]:#{u.inspect}"
            puts "studio[#{csv_row}]:#{row.inspect}"
          end

        else
          puts "errors:#{u.errors.full_messages}"
          puts "user[#{csv_row}]: raw_seed:#{u.raw_seed}"
          puts "user[#{csv_row}]:#{row.inspect}"
        end

      else
        puts "INVALID email[#{idx}]"
        puts "studio[#{idx}]:#{row.inspect}"
      end

    end
    puts "all done now go make some money"
  end

  desc "Seed Studios from Kimbra Spreadsheet using gmap"
  task :seed_gmap_studios => :environment do
    require 'csv'
    file = Rails.root.join("config", "kimbra_studios.csv")

    CSV.open(file.to_s, "r", headers: true).each_with_index do |row, idx|

      attrs = {address_1:           row["BADDR2"],
               address_2:           row["BADDR3"],
               phone_number:        row["PHONE1"],
               minisite_attributes: {bgcolor:     '#2a1907',
                                     font_color:  '#d3b492',
                                     font_family: 'Arial'},
               info_attributes:     {}}

      attrs[:name] = row["COMPANYNAME"] || row["NAME"] || row["CONT1"] || row["CONT2"]


      user_attrs = {email:      row["EMAIL"] || row["EMAIL2"],
                    address_1:  row['BADDR2'] || row['BADDR1'],
                    first_name: row["FIRSTNAME"],
                    last_name:  row["LASTNAME"],
                    password:   User.generate_random_text}
      if (user_attrs[:email].present?)

        attrs[:info_attributes][:website]         = row["WEBSITE"]
        attrs[:info_attributes][:tax_ein]         = row["TAX_ID"]
        attrs[:info_attributes][:commission_rate] = 10

        add3           = row["BADDR3"].to_s.strip.upcase
        add4           = row["BAADR4"].to_s.strip.upcase
        city_state_zip = add3 + "#{add3} #{add4}".gsub(add3, '')
        city_state_zip.strip!
        if (city_state_zip == 'TEMECULA, CA  00000')
          city_state_zip = 'TEMECULA, CA  92590'
        end
        user_attrs[:raw_seed]       = city_state_zip

                                      # country abbrev
        user_attrs[:country_abbrev] = row["BADDR5"].to_s.strip.upcase

        user_attrs[:email].downcase!
        attrs[:owner] = User.find_by_email(user_attrs[:email]) || User.new(user_attrs)
        attrs[:owner].skip_confirmation!
        attrs[:owner].use_gmap = true # use address info from gmap
        result                 = if (!attrs[:owner].new_record?)
                                   attrs[:owner].update_attributes(user_attrs)
                                 else
                                   attrs[:owner].save
                                 end

        if (!result)
          puts "errors:#{attrs[:owner].errors.full_messages}"
          puts "c_s_zip:#{city_state_zip}"
          puts "user[#{idx}]:#{attrs[:owner].raw_seed}"
          puts "user[#{idx}]:#{attrs[:owner].city}"
          puts "user[#{idx}]:#{row.inspect}"
        else
          u = attrs[:owner]
          puts "#{u.email} city:#{u.city} state:#{u.state} address:#{u.raw_seed}"
        end
      else
        puts "INVALID email[#{idx}]"
        puts "studio[#{idx}]:#{row.inspect}"
      end
      #if idx > 1
      #  break
      #end
    end
    puts "all done now go make some money"
  end


end