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
      dir 'photo_charms'
      file 'annika_charm.png'
    end

    before(:create) do |piece, evaluator|

      # expecting the following directory structure
      # kimbra
      # |
      # |-- photo_charms (:dir)
      # |
      # |---- annika_charm.png (:file)
      # |---- annika_charm
      # |
      # |-------- part0.png => part imaages

      category_dir   = evaluator.dir
      piece_dir      = evaluator.file.split('.').first
      piece.name     = piece_dir.titleize
      piece.category = category_dir.titleize

      # remove piece if it currently exists
      if (p = Admin::Merchandise::Piece.find_by_name_and_category(piece.name, piece.category))
        p.destroy
      end

      path        = Rails.root.join("public/kimbra", category_dir)
      piece.image = File.open(path.join(evaluator.file).to_s)

      # grab any parts
      Rails.logger.info("piece parts dir:#{path.join(piece_dir, '*png')}")

      # all the png images under the piece_dir
      Dir[path.join(piece_dir, "*.png")].each do |part_image|
        Rails.logger.info("piece part:#{part_image}")
        piece.parts << create(:part, path: path.to_s, file: part_image)
      end
    end
  end

end
