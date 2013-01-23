require 'spec_helper'

describe Admin::Merchandise::Piece do

  before(:all) do
    @upload_path = "/uploads/admin/merchandise/piece/image"
  end

  context "factories" do
    it 'has a admin_merchandise_piece' do
      r = create(:admin_merchandise_piece)
      r.should be_persisted
      r.category.name.should == 'Photo Charms'
      r.name.should == 'Annika Charm'
      r.short_description.should_not be_nil
      r.parts.size.should   == 1
      part = r.parts.first
      part.should be_persisted

      r.image.url.should == "#{@upload_path}/#{r.id}/annika_charm.png"
      r.image.identifier.should == 'annika_charm.png'
      r.width.should == 200
      r.height.should == 200
    end

    context "aliases and traits" do

      it 'has a piece with dir and file' do
        file = 'iphone_3_case.png'
        r = create(:piece, dir: 'photo_accessories', file: file)
        r.should be_persisted
        r.image.url.should == "#{@upload_path}/#{r.id}/#{file}"
        r.image.identifier.should == file
        r.width.should == 350
        r.height.should == 350
        r.parts.size.should   == 1
      end

    end
  end

  context 'ar validations' do
    # currently are none
  end

end
