require 'spec_helper'

describe MyStudio::Session do

  def valid_factory_session(s)
    s.should be_persisted
    s.category.should be_persisted
    s.client.should be_persisted
    s.studio.should be_persisted
    s.finished_uploading_at.should be_nil
  end

  context 'factories' do
    it 'has a my_studio_session' do
      r = create(:my_studio_session)
      valid_factory_session(r)
    end

    context 'aliases and traits' do

      it 'has with_portraits' do
        r = create(:my_studio_session, :with_portraits)
        valid_factory_session(r)
        r.portraits.size.should == 1
        r.emails.size.should == 0
      end

      it 'has with_portraits with count' do
        r = create(:my_studio_session, :with_portraits, portraits_count: 3)
        valid_factory_session(r)
        r.portraits.size.should == 3
        r.emails.size.should == 0
      end

      it 'has with_emails' do
        r = create(:my_studio_session, :with_emails)
        valid_factory_session(r)
        r.portraits.size.should == 0
        r.emails.size.should == 1
      end
    end
  end

  context 'ar validations' do

    context 'associations' do
      it 'has client' do
        r = build(:my_studio_session, client: nil)
        r.valid?.should == false
      end
      it 'has studio' do
        r = build(:my_studio_session, studio: nil)
        r.valid?.should == false
      end

      it 'has category' do
        r = build(:my_studio_session, category: nil)
        r.valid?.should == false
      end
    end
  end

end
