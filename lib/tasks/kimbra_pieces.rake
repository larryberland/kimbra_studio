namespace 'kimbra_pieces' do
  desc "Seed the new photo_accessories for merchandise pieces"
  task :accessories => :environment do
    category = "Photo Accessories"
    images   = %w(calvin_photo_keychain.jpeg
    everyday_photo_keychain.jpeg
    iphone_3_case.jpeg
    iphone_4_case.jpeg
    iphone_5_case.jpeg
    leather_photo_bag_tag.jpeg
    napa_photo_wine_charms_vertical.jpeg
    napa_photo_wine_charms.jpeg
    napa_wine_stopper_horizontal.jpeg
    napa_wine_stopper_vertical.jpeg
    owen_photo_bottle_opener.jpeg
    photo_key_chain_bag_tag.jpeg
    raney_photo_purse_charm.jpeg
    round_pill_box.jpeg
    studio_photo_business_card_holder.jpeg
    willard_photo_key_chain.jpeg)

    data = [{name:  'Calvin Photo Keychain',
             price: "24.00", short_description: 'Photo measuring: 1" round. Leather keychain. Completely waterproof.', description_markup: ''},

            {name:  'Everyday Photo Keychain',
             price: "24.00", short_description: 'Photo measuring: 1" square. Pewter photo charm. Completely Waterproof.', description_markup: ''},

            {name:  'iPhone 3 Case',
             price: "35.00", short_description: "The best-selling iPhone 3/3S case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone. Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack.
             The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!", description_markup: ''},

            {name:  "iPhone 4 Case",
             price: "35.00", short_description: "The best-selling iPhone 4/4S case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone. Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack.
             The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!", description_markup : ""},

            {name:  "iPhone 5 Case",
             price: "35.00", short_description: "The best-selling iPhone 5/5S case is ultra-lightweight with a slim silhouette that enhances the overall aesthetic of the phone. Express yourself by creating an individual design that no one else has. Simply choose your own picture to be wrapped around the entire case. Images have brilliant color and clarity and won't fade, peel or crack.
             The slender impact-resistant polycarbonate shell protects against falls and maintains access to all of your device features. The smooth finish makes it simple to slide in and out of pockets. Made in the USA!", description_markup : ""},

            {name:  "Leather Photo Bag Tag",
             price: "36.00", short_description: "Photo measuring 2\" round. Round leather bag tag with buckle attachment. Completely waterproof.", description_markup : ""},

            {name:  "Napa Photo Wine Charms (set of 2) Vertical",
             part_layouts: [
                        {x: 41, y: 23, w: 182, h: 132},
                        {x: 41, y: 23, w: 182, h: 132}
                          ],
             price: "20.00", short_description: 'Pewter Wine Charms - Set of 2. Pairs with our Pewter Napa Wine Stop. Photo Size: 3/8" x 1/2"', description_markup : ""},

            {name:  "Napa Photo Wine Charms (set of 2) Horizontal",
             part_layouts: [
                        {x: 41, y: 23, w: 182, h: 132},
                        {x: 41, y: 23, w: 182, h: 132}
                          ],
             price: "20.00", short_description: 'Pewter Wine Charms - Set of 2. Pairs with our Pewter Napa Wine Stop. Photo Size: 1/2" x 3/8"', description_markup : ""},

            {name:  "Napa Wine Stopper Horizontal",
             price: "42.00", short_description: 'Pewter Wine Cork. Pairs with our set of Pewter Wine charms. Photo size: 1 3/8" x 1"', description_markup : ""},

            {name:  "Napa Wine Stopper Vertical",
             price: "42.00", short_description: 'Pewter Wine Cork. Pairs with our set of Pewter Wine Charms. Photo size: 1" x 1 3/8"', description_markup : ""},

            {name:  "Owen Photo Bottle Opener",
             price: "26.00", short_description: 'Photo measuring: 1-1/4"w x 3"h. Alloy/Pewter. Completely waterproof. Magnetic Back keeps it handy!', description_markup : ""},

            {name:  "Photo Key Chain/Bag tag",
             price: "28.00", short_description: 'Solid pewter photo charm measuring 1" square. Comes with trigger snap attachment and key ring. Completely waterproof.', description_markup : ""},

            {name:  "Raney Photo Purse Charm",
             price: "38.00", short_description: 'Solid pewter photo charm measuring 1" square. Comes with trigger snap attachment and pewter crystal heart charm.', description_markup : ""},

            {name:  "Round Pill Box",
             price: "30.00", short_description: 'Measuring: 1-1/2" round. Mirror inside lid. Silver tone finish. Completely waterproof.', description_markup : ""},

            {name:  "Studio Photo Business Card Holder",
             price: "32.00", short_description: 'Photo measuring: 3-1/2"w x 2"h. Brushed metal finish. Completely waterproof.', description_markup : ""},

            {name:  "Willard Photo Key Chain",
             price: "32.00", short_description: 'Photo measuring: 1-1/4" square. Pewter and Genuine Leather. ', description_markup : ""}]

    data = [
        {name:         'Alexis Bracelet', image: 'alexis_bracelet.png',
         layouts:      [{x: 108, y: 48, w: 70, h: 83},],
         part_layouts: [{x: 41, y: 23, w: 182, h: 132}],
        },
    ]
    path = Rails.root.join('public', 'kimbra', 'photo_accessories')
    images.each_with_index do |file, i|
      puts "[#{i}] file=>'#{file}'"

      data[i][:image]    = file
      data[i][:category] = category
      data[i][:active] = false
      data[i][:photo] = true
      data[i][:custom_layout] = "composite"

    end

  end

end