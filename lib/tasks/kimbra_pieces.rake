namespace 'kimbra_pieces' do
  desc "Seed the photo_bracelets for merchandise pieces"
  task :bracelets => :environment do
    category = "Photo Bracelets"
    images   = %w(alexis_bracelet.png)

    data = [
        {name:   "Alexis Bracelet",
         active: true,
         parts:  [
                     {part_layout_attributes:  {layout_attributes: {x: 71, y: 96, w: 135, h: 161}},
                      piece_layout_attributes: {layout_attributes: {x: 107, y: 49, w: 68, h: 81}}
                     },
                     {part_layout_attributes:  {layout_attributes: {x: 75, y: 96, w: 137, h: 162}},
                      piece_layout_attributes: {layout_attributes: {x: 227, y: 48, w: 68, h: 82}}
                     },
                     {part_layout_attributes:  {layout_attributes: {x: 71, y: 97, w: 138, h: 162}},
                      piece_layout_attributes: {layout_attributes: {x: 344, y: 48, w: 70, h: 82}}
                     },
                     {part_layout_attributes:  {layout_attributes: {x: 70, y: 96, w: 136, h: 164}},
                      piece_layout_attributes: {layout_attributes: {x: 463, y: 48, w: 69, h: 81}}
                     },
                     {part_layout_attributes:  {layout_attributes: {x: 71, y: 96, w: 136, h: 161}},
                      piece_layout_attributes: {layout_attributes: {x: 579, y: 48, w: 69, h: 82}}
                     },
                 ],
        }
    ]
    path = Rails.root.join('public', 'kimbra', 'photo_bracelets')

    images.each_with_index do |file, i|

      info = data[i]

      info[:category] = category
      unless info.key?(:active)
        info[:active] = false
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


        if my_part = p.parts.select{|r|r.order == order}.first
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

  desc "Seed the new photo_accessories for merchandise pieces"
  task :accessories => :environment do
    category = "Photo Accessories"
    images   = %w(calvin_photo_keychain.png
    everyday_photo_keychain.png
    iphone_3_case.png
    iphone_3_case_horizontal.png
    iphone_4_case.png
    iphone_4_case_horizontal.png
    iphone_5_case.png
    iphone_5_case_horizontal.png
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
    studio_photo_business_card_holder_horizontal.png
    willard_photo_key_chain.png)

    data = [{name:           'Calvin Photo Keychain',
             active:         true,
             use_part_image: true,
             parts:          [
                                 {part_layout_attributes:  {layout_attributes: {x: 78, y: 218, w: 137, h: 137}},
                                  piece_layout_attributes: {layout_attributes: {x: 78, y: 218, w: 137, h: 137}}
                                 },
                             ],
             price:          "24.00", short_description: 'Photo measuring: 1" round. Leather keychain. Completely waterproof.', description_markup: ''},

            {name:           'Everyday Photo Keychain',
             active:         true,
             use_part_image: true,
             parts:          [
                                 {part_layout_attributes:  {layout_attributes: {x: 98, y: 280, w: 95, h: 95}},
                                  piece_layout_attributes: {layout_attributes: {x: 98, y: 280, w: 95, h: 95}}
                                 },
                             ],
             price:          "24.00", short_description: 'Photo measuring: 1" square. Pewter photo charm. Completely Waterproof.', description_markup: ''},

            {name:               'iPhone 3 Case',
             active:             true,
             parts:              [
                                     {part_layout_attributes:  {layout_attributes: {x: 44, y: 25, w: 160, h: 304}},
                                      piece_layout_attributes: {layout_attributes: {x: 36, y: 30, w: 160, h: 304, degrees: -2.5}}
                                     },
                                 ],
             price:              "35.00",
             short_description:  "The best-selling iPhone 3 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone.",
             description_markup: "Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack. The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!",
            },

            {name:               'iPhone 3 Case Horizontal',
             active:             true,
             parts:              [
                                     {part_layout_attributes:  {layout_attributes: {x: 27, y: 46, w: 304, h: 160}},
                                      piece_layout_attributes: {layout_attributes: {x: 15, y: 50, w: 304, h: 160, degrees: -2.5}}
                                     },
                                 ],
             price:              "35.00",
             short_description:  "The best-selling iPhone 3 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone.",
             description_markup: "Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack. The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!",
            },

            {name:               "iPhone 4 Case",
             active:             true,
             use_part_image:     true,
             parts:              [
                                     {part_layout_attributes:  {layout_attributes: {x: 137, y: 23, w: 156, h: 308}},
                                      piece_layout_attributes: {layout_attributes: {x: 137, y: 23, w: 156, h: 308}}
                                     },
                                 ],
             price:              "35.00",
             short_description:  "The best-selling iPhone 4 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone.",
             description_markup: "Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack. The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!",
            },

            {name:               "iPhone 4 Case Horizontal",
             active:             true,
             use_part_image:     true,
             parts:              [
                                     {part_layout_attributes:  {layout_attributes: {x: 18, y: 141, w: 308, h: 156}},
                                      piece_layout_attributes: {layout_attributes: {x: 18, y: 141, w: 308, h: 156}}
                                     },
                                 ],
             price:              "35.00",
             short_description:  "The best-selling iPhone 4 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone.",
             description_markup: "Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack. The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!",
            },

            {name:               "iPhone 5 Case",
             active:             true,
             parts:              [
                                     {part_layout_attributes:  {layout_attributes: {x: 114, y: 27, w: 146, h: 301}},
                                      piece_layout_attributes: {layout_attributes: {x: 45, y: 26, w: 146, h: 301}}
                                     },
                                 ],
             price:              "35.00",
             short_description:  "The best-selling iPhone 5 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone.",
             description_markup: "Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack. The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!",
            },

            {name:               "iPhone 5 Case Horizontal",
             active:             true,
             parts:              [
                                     {part_layout_attributes:  {layout_attributes: {x: 21, y: 115, w: 301, h: 146}},
                                      piece_layout_attributes: {layout_attributes: {x: 25, y: 48, w: 301, h: 146}}
                                     },
                                 ],
             price:              "35.00",
             short_description:  "The best-selling iPhone 5 case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone.",
             description_markup: "Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack. The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!",
            },

            {name:   "Leather Photo Bag Tag",
             active: true,
             parts:  [
                         {part_layout_attributes:  {layout_attributes: {x: 106, y: 211, w: 103, h: 103}},
                          piece_layout_attributes: {layout_attributes: {x: 145, y: 253, w: 103, h: 103, degrees: -44.01}}
                         },
                     ],
             price:  "36.00", short_description: "Photo measuring 2\" round. Round leather bag tag with buckle attachment. Completely waterproof.", description_markup: ""},

            {name:   "Napa Photo Wine Charms (set of 2) Vertical",
             active: true,
             parts:  [
                         {part_layout_attributes:  {layout_attributes: {x: 65, y: 190, w: 52, h: 68}},
                          piece_layout_attributes: {layout_attributes: {x: 82, y: 197, w: 52, h: 68, degrees: -19.13},
                                                    operator:          'SrcOverCompositeOp'}
                         },
                         {part_layout_attributes:  {layout_attributes: {x: 65, y: 190, w: 52, h: 68}},
                          piece_layout_attributes: {layout_attributes: {x: 256, y: 213, w: 52, h: 68, degrees: -19.13},
                                                    operator:          'SrcOverCompositeOp'}

                         },
                     ],
             price:  "20.00", short_description: 'Pewter Wine Charms - Set of 2. Pairs with our Pewter Napa Wine Stop. Photo Size: 3/8" x 1/2"', description_markup: ""},

            {name:   "Napa Photo Wine Charms (set of 2) Horizontal",
             active: true,
             parts:  [
                         {part_layout_attributes:  {layout_attributes: {x: 67, y: 204, w: 73, h: 59}},
                          piece_layout_attributes: {layout_attributes: {x: 80, y: 212, w: 73, h: 59, degrees: -16.39},
                                                    operator:          'SrcOverCompositeOp'}
                         },
                         {part_layout_attributes:  {layout_attributes: {x: 67, y: 204, w: 74, h: 59}},
                          piece_layout_attributes: {layout_attributes: {x: 239, y: 223, w: 74, h: 59, degrees: -16.39},
                                                    operator:          'SrcOverCompositeOp'}
                         },
                     ],
             price:  "20.00", short_description: 'Pewter Wine Charms - Set of 2. Pairs with our Pewter Napa Wine Stop. Photo Size: 1/2" x 3/8"', description_markup: ""},

            {name:   "Napa Wine Stopper Horizontal",
             active: true,
             parts:  [
                         {part_layout_attributes:  {layout_attributes: {x: 80, y: 56, w: 151, h: 111}},
                          piece_layout_attributes: {layout_attributes: {x: 56, y: 74, w: 151, h: 111, degrees: -12.21}}
                         },
                     ],
             price:  "42.00", short_description: 'Pewter Wine Cork. Pairs with our set of Pewter Wine charms. Photo size: 1 3/8" x 1"', description_markup: ""},

            {name:   "Napa Wine Stopper Vertical",
             active: true,
             parts:  [
                         {part_layout_attributes:  {layout_attributes: {x: 116, y: 58, w: 75, h: 100}},
                          piece_layout_attributes: {layout_attributes: {x: 104, y: 64, w: 75, h: 100, degrees: -7.66},
                                                    operator:          'SrcOverCompositeOp'}},
                     ],
             price:  "42.00", short_description: 'Pewter Wine Cork. Pairs with our set of Pewter Wine Charms. Photo size: 1" x 1 3/8"', description_markup: ""},

            {name:   "Owen Photo Bottle Opener",
             active: true,
             parts:  [
                         {part_layout_attributes:  {layout_attributes: {x: 137, y: 82, w: 333, h: 139}},
                          piece_layout_attributes: {layout_attributes: {x: 164, y: 69, w: 353, h: 139, degrees: 5.53}}
                         },
                     ],
             price:  "26.00", short_description: 'Photo measuring: 3"w x 1-1/4"h. Alloy/Pewter. Completely waterproof. Magnetic Back keeps it handy!', description_markup: ""},

            {name:   "Photo Key Chain/Bag tag",
             active: true,
             parts:  [
                         {part_layout_attributes:  {layout_attributes: {x: 120, y: 185, w: 80, h: 80}},
                          piece_layout_attributes: {layout_attributes: {x: 134, y: 193, w: 80, h: 80, degrees: -18.64}}
                         },
                     ],
             price:  "28.00", short_description: 'Solid pewter photo charm measuring 1" square. Comes with trigger snap attachment and key ring. Completely waterproof.', description_markup: ""},

            {name:           "Raney Photo Purse Charm",
             active:         true,
             use_part_image: true,
             parts:          [
                                 {part_layout_attributes:  {layout_attributes: {x: 96, y: 325, w: 103, h: 100}},
                                  piece_layout_attributes: {layout_attributes: {x: 96, y: 325, w: 103, h: 100}}
                                 },
                             ],
             price:          "38.00", short_description: 'Solid pewter photo charm measuring 1" square. Comes with trigger snap attachment and pewter crystal heart charm.', description_markup: ""},

            {name:           "Round Pill Box",
             active:         true,
             use_part_image: true,
             parts:          [
                                 {part_layout_attributes:  {layout_attributes: {x: 49, y: 61, w: 176, h: 178}},
                                  piece_layout_attributes: {layout_attributes: {x: 49, y: 61, w: 176, h: 178}}
                                 },
                             ],
             price:          "30.00", short_description: 'Measuring: 1-1/2" round. Mirror inside lid. Silver tone finish. Completely waterproof.', description_markup: ""},

            {name:   "Studio Photo Business Card Holder",
             active: true,
             parts:  [
                         {part_layout_attributes:  {layout_attributes: {x: 82, y: 44, w: 115, h: 209}},
                          piece_layout_attributes: {layout_attributes: {x: 45, y: 82, w: 115, h: 209, degrees: -25.01}}
                         },
                     ],
             price:  "32.00", short_description: 'Photo measuring: 2"w x 3-1/2"h. Brushed metal finish. Completely waterproof.', description_markup: ""},

            {name:   "Studio Photo Business Card Holder Horizontal",
             active: true,
             parts:  [
                         {part_layout_attributes:  {layout_attributes: {x: 47, y: 82, w: 210, h: 117}},
                          piece_layout_attributes: {layout_attributes: {x: 47, y: 82, w: 210, h: 117}}
                         },
                     ],
             price:  "32.00", short_description: 'Photo measuring: 3-1/2"w x 2"h. Brushed metal finish. Completely waterproof.', description_markup: ""},

            {name:           "Willard Photo Key Chain",
             active:         true,
             use_part_image: true,
             parts:          [
                                 {part_layout_attributes:  {layout_attributes: {x: 62, y: 283, w: 172, h: 173}},
                                  piece_layout_attributes: {layout_attributes: {x: 62, y: 283, w: 172, h: 173}}
                                 },
                             ],
             price:          "32.00", short_description: 'Photo measuring: 1-1/4" square. Pewter and Genuine Leather. ', description_markup: ""}]

    path           = Rails.root.join('public', 'kimbra', 'photo_accessories')
    default_layout = {x: 0, y: 0, w: 100, h: 100}

    images.each_with_index do |file, i|

      info = data[i]

      info[:category] = category
      unless info.key?(:active)
        info[:active] = false
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

        if my_part = p.parts.select{|r|r.order == order}.first
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