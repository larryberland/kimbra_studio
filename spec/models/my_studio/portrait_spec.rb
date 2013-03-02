require 'spec_helper'
require 'carrierwave/test/matchers'

describe MyStudio::Portrait do
  include CarrierWave::Test::Matchers

  before do
    @upload_path = '/uploads/my_studio/portrait/image'
  end

  context 'factories' do
    it 'has a my_studio_portrait' do
      r = create(:my_studio_portrait)
      r.should be_persisted
      url = "#{@upload_path}/#{r.id}/portrait.png"
      r.image.url.should == url
      # "/Users/larryb/RubymineProjects/kimbra_studio/public/uploads/my_studio/portrait/image/:id/portrait.png"
      r.image.current_path == Rails.root.join('public').to_s + url
      r.image.identifier.should == 'portrait.png'
      r.width.should  == 183
      r.height.should == 275
    end

    context 'aliases and traits' do

      it 'has a file' do
        file = 'landscape.png'
        r = create(:portrait, file: file)
        r.should be_persisted
        url = "#{@upload_path}/#{r.id}/#{file}"
        r.image.url.should == url
        # "/Users/larryb/RubymineProjects/kimbra_studio/public/uploads/my_studio/portrait/image/:id/:file"
        r.image.current_path == Rails.root.join('public').to_s + url
        r.image.identifier.should == file
        r.width.should  == 400
        r.height.should == 338
      end

      it 'has a with_landscape' do
        file = 'landscape.png'
        r = create(:portrait, :with_landscape)
        r.should be_persisted
        url = "#{@upload_path}/#{r.id}/#{file}"
        r.image.url.should == url
        # "/Users/larryb/RubymineProjects/kimbra_studio/public/uploads/my_studio/portrait/image/:id/:file"
        r.image.current_path == Rails.root.join('public').to_s + url
        r.image.identifier.should == file
        r.description = 'usually the file name'
        r.width.should  == 400
        r.height.should == 338
      end
    end
  end

end
