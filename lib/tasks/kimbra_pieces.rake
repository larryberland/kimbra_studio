namespace 'kimbra_pieces' do
  desc "Seed the new photo_accessories for merchandise pieces"
  task :accessories => :environment do
    category = "Photo Accessories"
    images   = %w(calvin_photo_keychain.png
    everyday_photo_keychain.jpeg
    iphone_3_case.jpeg
    iphone_4_case.jpeg
    iphone_5_case.jpeg
    leather_photo_bag_tag.png
    napa_photo_wine_charms_vertical.png
    napa_photo_wine_charms.png
    napa_wine_stopper_horizontal.png
    napa_wine_stopper_vertical.png
    owen_photo_bottle_opener.png
    photo_key_chain_bag_tag.png
    raney_photo_purse_charm.png
    round_pill_box.png
    studio_photo_business_card_holder.png
    willard_photo_key_chain.png)

    data = [{name:  'Calvin Photo Keychain',
             active: true,
             use_part_image: true,
             parts: [
                        {part_layout_attributes:  {layout_attributes: {x: 78, y: 218, w: 137, h: 137}},
                         piece_layout_attributes: {layout_attributes: {x: 78, y: 218, w: 137, h: 137}}
                        },
                    ],
             price: "24.00", short_description: 'Photo measuring: 1" round. Leather keychain. Completely waterproof.', description_markup: ''},

            {name:  'Everyday Photo Keychain',
             price: "24.00", short_description: 'Photo measuring: 1" square. Pewter photo charm. Completely Waterproof.', description_markup: ''},

            {name:               'iPhone 3 Case',
             price:              "35.00",
             short_description:  "The best-selling iPhone 3 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone.",
             description_markup: "The best-selling iPhone 3 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone. Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack.
             The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!",
            },

            {name:               "iPhone 4 Case",
             price:              "35.00",
             short_description:  "The best-selling iPhone 4 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone.",
             description_markup: "The best-selling iPhone 4 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone. Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack.
             The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!",
            },

            {name:               "iPhone 5 Case",
             price:              "35.00",
             short_description:  "The best-selling iPhone 5 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone.",
             description_markup: "The best-selling iPhone 5 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone. Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack.
             The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!",
            },

            {name:  "Leather Photo Bag Tag",
             price: "36.00", short_description: "Photo measuring 2\" round. Round leather bag tag with buckle attachment. Completely waterproof.", description_markup: ""},

            {name:  "Napa Photo Wine Charms (set of 2) Vertical",
             active: true,
             parts: [
                        {part_layout_attributes:  {layout_attributes: {x: 65, y: 190, w: 52, h: 68}},
                         piece_layout_attributes: {layout_attributes: {x: 82, y: 197, w: 52, h: 68, degrees: -19.13},
                                                   operator: 'SrcOverCompositeOp'}
                        },
                        {part_layout_attributes:  {layout_attributes: {x: 65, y: 190, w: 52, h: 68}},
                         piece_layout_attributes: {layout_attributes: {x: 256, y: 213, w: 52, h: 68, degrees: -19.13},
                                                   operator: 'SrcOverCompositeOp'}

                        },
                    ],
             price: "20.00", short_description: 'Pewter Wine Charms - Set of 2. Pairs with our Pewter Napa Wine Stop. Photo Size: 3/8" x 1/2"', description_markup: ""},

            {name:  "Napa Photo Wine Charms (set of 2) Horizontal",
             active: true,
             parts: [
                        {part_layout_attributes:  {layout_attributes: {x: 67, y: 204, w: 73, h: 59}},
                         piece_layout_attributes: {layout_attributes: {x: 80, y: 212, w: 73, h: 59, degrees: -16.39},
                                                   operator: 'SrcOverCompositeOp'}
                        },
                        {part_layout_attributes:  {layout_attributes: {x: 67, y: 204, w: 74, h: 59}},
                         piece_layout_attributes: {layout_attributes: {x: 239, y: 223, w: 74, h: 59, degrees: -16.39},
                                                   operator: 'SrcOverCompositeOp'}

                        },
                    ],
             price: "20.00", short_description: 'Pewter Wine Charms - Set of 2. Pairs with our Pewter Napa Wine Stop. Photo Size: 1/2" x 3/8"', description_markup: ""},

            {name:  "Napa Wine Stopper Horizontal",
             price: "42.00", short_description: 'Pewter Wine Cork. Pairs with our set of Pewter Wine charms. Photo size: 1 3/8" x 1"', description_markup: ""},

            {name:  "Napa Wine Stopper Vertical",
             price: "42.00", short_description: 'Pewter Wine Cork. Pairs with our set of Pewter Wine Charms. Photo size: 1" x 1 3/8"', description_markup: ""},

            {name:  "Owen Photo Bottle Opener",
             price: "26.00", short_description: 'Photo measuring: 1-1/4"w x 3"h. Alloy/Pewter. Completely waterproof. Magnetic Back keeps it handy!', description_markup: ""},

            {name:  "Photo Key Chain/Bag tag",
             price: "28.00", short_description: 'Solid pewter photo charm measuring 1" square. Comes with trigger snap attachment and key ring. Completely waterproof.', description_markup: ""},

            {name:  "Raney Photo Purse Charm",
             price: "38.00", short_description: 'Solid pewter photo charm measuring 1" square. Comes with trigger snap attachment and pewter crystal heart charm.', description_markup: ""},

            {name:  "Round Pill Box",
             price: "30.00", short_description: 'Measuring: 1-1/2" round. Mirror inside lid. Silver tone finish. Completely waterproof.', description_markup: ""},

            {name:  "Studio Photo Business Card Holder",
             price: "32.00", short_description: 'Photo measuring: 3-1/2"w x 2"h. Brushed metal finish. Completely waterproof.', description_markup: ""},

            {name:  "Willard Photo Key Chain",
             price: "32.00", short_description: 'Photo measuring: 1-1/4" square. Pewter and Genuine Leather. ', description_markup: ""}]

    path           = Rails.root.join('public', 'kimbra', 'photo_accessories')
    default_layout = {x: 0, y: 0, w: 100, h: 100}

    images.each_with_index do |file, i|

      info = data[i]

      info[:category]      = category
      unless info.key?(:active)
        info[:active]        = false
      end
      info[:photo]         = true
      info[:custom_layout] = "composite"

      puts "piece=>#{info[:name]}"
      p = Admin::Merchandise::Piece.find_or_create_by_category_and_name(info[:category], info[:name])
      p.update_attributes(info)

      # kimbra piece image
      piece_image_fname = file
      if piece_image_fname
        fname = path.join(piece_image_fname)
        if File.exist?(fname.to_s)
          p.image.store!(File.open(fname.to_s))
        else
          puts "missing Piece image fname=>#{piece_image_fname} in #{info[:category]}/#{info[:name]} image=>#{fname}"
          next
        end
      end

      # handle the piece's parts
      sub_dir = file.split('.').first
      parts   = info.delete(:parts)
      parts   ||= [{}]

      # create the new parts
      parts.each_with_index do |part, order|

        attrs = {piece: p, order: order}
        attrs[:part_layout_attributes] = part[:part_layout_attributes] if part.key?(:part_layout_attributes)
        attrs[:piece_layout_attributes] = part[:piece_layout_attributes] if part.key?(:piece_layout_attributes)

        if my_part = p.parts[order]
          my_part.update_attributes(attrs)
        else
          my_part = Admin::Merchandise::Part.create(attrs)
          p.parts << my_part
        end

        # update the parts transparent image
        p2 = path.join(sub_dir, "part_#{order}.png")
        f  = if (File.exist?(p2.to_s))
               p2.to_s
             else
               path.join(sub_dir, file).to_s
             end
        my_part.image_part.store!(File.open(f))
        my_part.save

      end

      p.update_attributes(info)
      p.parts.each { |r| r.save }

      puts "#{p.id} #{p.width}x#{p.height} price:#{p.price} #{file}"

    end

  end

end