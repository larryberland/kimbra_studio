# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  #create_table "my_studio_minisites", :force => true do |t|
  #  t.integer  "studio_id"
  #  t.string   "bgcolor"
  #  t.string   "image"
  #  t.string   "font_family"
  #  t.string   "font_color"
  #  t.string   "theme"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #  t.integer  "image_width"
  #  t.integer  "image_height"
  #end
  factory :my_studio_minisite, class: 'MyStudio::Minisite', aliases: [:minisite] do
    bgcolor    "#aabbcc"
    font_color "#ccbbaa"
    font_family "Arial"

    ignore do
      # pass in a different file name in the public/studios/:dir/:file directory
      #   create(:minisite, dir: studio_one/minisite file: 'studiog_logo.png')
      dir 'studio_one/minisite'
      file 'studiog_logo.png'
    end

    before(:create) do |minisite, evaluator|
      minisite.image = File.open(Rails.root.join("public/studios", evaluator.dir, evaluator.file).to_s)
    end
  end
end
