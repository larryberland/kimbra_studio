require 'spec_helper'

describe Studio do

  def valid_factory_studio(s)
    s.should be_persisted
    s.state.should_not be_nil
    s.country.should_not be_nil
    s.info.should_not be_nil
    s.info.website.should == 'http://wwww.mystudioinfo.com'
    s.minisite.should_not be_nil
    s.owner.should_not be_nil
    s.minisite.image_width.should == 277
    s.minisite.image_height.should == 174
  end

  context 'factories' do

    it 'has a studio' do
      s = create(:studio)
      valid_factory_studio(s)
    end

    context 'aliases and traits' do

      it 'has with_session' do
        r = create(:studio, :with_session)
        valid_factory_studio(r)
        r.sessions.size.should == 1
      end

      it 'has with_session and count' do
        r = create(:studio, :with_session, sessions_count: 3)
        valid_factory_studio(r)
        r.sessions.size.should == 3
      end

    end
  end

  context 'ar validations' do

  end


end
