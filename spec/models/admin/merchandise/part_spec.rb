require 'spec_helper'

describe Admin::Merchandise::Part do

  before do
    @upload_path = '/uploads/admin/merchandise/part/image_part'
  end

  context 'factories' do
    it 'has a admin_merchandise_part' do
      r = create(:admin_merchandise_part)
      r.should be_persisted
      url = "#{@upload_path}/#{r.id}/part_charm.png"
      r.image_part.url.should == url
      r.image_part.current_path == Rails.root.join('public').to_s + url
      r.image_part.identifier.should == 'part_charm.png'
      r.image_part_width.should == 131
      r.image_part_height.should == 179
      r.width.should == 131
      r.height.should == 179

      # no image created yet so using our fallback
      url = '/images/fallback/empty_deal_image.png'
      r.image.url.should == url
      r.image.current_path == Rails.root.join('public').to_s + url
      r.image.identifier.should be_nil
      r.image_width.should be_nil
      r.image_height.should be_nil

      # part_layout
      r.part_layout.should be_persisted
      r.part_layout.x.should == 10
      r.part_layout.y.should == 10
      r.part_layout.w.should == r.image_part_width - 20
      r.part_layout.h.should == r.image_part_height - 20

      # piece_layout


    end

    context 'aliases and traits' do

      it 'has a part for a specific piece' do
        file = 'part_0.png'
        r = create(:part, dir: 'photo_bracelets/alexis_bracelet', file: file)
        r.should be_persisted
        url = "#{@upload_path}/#{r.id}/#{file}"
        r.image_part.url.should == url
        r.image_part.current_path == Rails.root.join('public').to_s + url
        r.image_part.identifier.should == file
        r.image_part_width.should == 280
        r.image_part_height.should == 334
        r.width.should == 280
        r.height.should == 334
      end
    end
  end

end
