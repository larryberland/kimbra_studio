# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  #create_table "admin_merchandise_pieces", :force => true do |t|
  #  t.string   "category"
  #  t.string   "name"
  #  t.string   "image"
  #  t.string   "short_description"
  #  t.text     "description_markup"
  #  t.string   "sku"
  #  t.decimal  "price"
  #  t.string   "custom_layout",      :default => "order"
  #  t.integer  "width",              :default => 0
  #  t.integer  "height",             :default => 0
  #  t.boolean  "active",             :default => true
  #  t.boolean  "featured"
  #  t.datetime "deleted_at"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #  t.boolean  "photo"
  #  t.boolean  "use_part_image"
  #end

  factory :admin_merchandise_piece, class: 'Admin::Merchandise::Piece', aliases: [:piece] do
    short_description "Short description of kimbra piece"
    description_markup "Longer description of kimbra piece with markup"
    sku "123Xyz"
    price 100.0
    custom_layout "composite"
    active true
    featured false
    photo true
    use_part_image false

    #image
    ignore do
      # pass in a different directory or name
      #   that exist in the public/kimbra/:piece_directory/:piece_name.png
      #   create(:piece, piece_directory: 'photo_bracelets', piece_name: 'alexis_bracelet')
      piece_directory 'photo_charms'
      piece_name 'annika_charm'
    end

    before(:create) do |piece, evaluator|

      Rails.logger.info("ev:#{evaluator.inspect}")
      a = evaluator.piece_directory
      puts "a:#{a}"
      piece.name = evaluator.piece_name.titleize
      piece.category = Category.find_or_create_by_name(evaluator.piece_directory.titleize)

      file_name = evaluator.piece_name + ".png"
      path = Rails.root.join("public/kimbra", evaluator.piece_directory)
      piece.image = File.open(path.join(file_name).to_s)

      # grab any parts
      Rails.logger.info("piece parts dir:#{path.join('*png')}")

      Dir[path.join("*.png")].each do |part_image|
        Rails.logger.info("piece part:#{part_image}")
        piece.parts << create(:part, path: path.to_s, file: part_image)
      end
    end


    trait :with_part do
      after :create do |piece|
        FactoryGirl.create_list :part, 1, piece: piece
      end
    end

    factory :piece_with_parts do
      ignore do
        parts_count 3
      end

      after(:create) do |piece, evaluator|
        FactoryGirl.create_list(:part, evaluator.parts_count, piece: piece)
      end
    end
  end
end
