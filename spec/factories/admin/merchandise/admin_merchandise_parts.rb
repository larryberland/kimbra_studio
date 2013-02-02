# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  #create_table "admin_merchandise_parts", :force => true do |t|
  #  t.integer "piece_id"
  #  t.integer "portrait_id"
  #  t.string "image_part"
  #  t.string "image"
  #  t.integer "order", :default => 0
  #  t.boolean "photo", :default => true
  #  t.integer "image_width"
  #  t.integer "image_height"
  #  t.integer "image_part_width"
  #  t.integer "image_part_height"
  #  t.boolean "active", :default => true
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end

  factory :admin_merchandise_part, class: 'Admin::Merchandise::Part', aliases: [:part] do
    piece { build(:admin_merchandise_piece) }

    ignore do
      # default piece directory path for a specific part background
      full_path nil
      path 'public/kimbra'
      dir '' # photo_? directory
      file 'part_charm.png'
    end

    before(:create) do |part, evaluator|
      #image_part, image_part_width, image_part_height
      file_path = if evaluator.full_path
                    evaluator.full_path
                  else
                    Rails.root.join(evaluator.path, evaluator.dir, evaluator.file)
                  end
      Rails.logger.info("part file_path:#{file_path}")

      # background image of the part inside the piece
      part.image_part = File.open(Rails.root.join(file_path).to_s)
      #part.image_part.save!

      Rails.logger.info("image_part #{part.width}x#{part.height}")
      if part.image_part_width > 0
         layout = ImageLayout.create(x: 10, y: 10, w: part.width-20, h: part.height-20)
         part.part_layout = PartLayout.create(part: part, layout: layout)
      end

    end

    trait :with_portrait do
      after :create do |part|
        part.portrait = build(:my_studio_portrait)
      end
    end

  end
end
