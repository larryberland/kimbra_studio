module Store

  def setup
    Admin::Merchandise::Piece.destroy_all
    create_charms
    create_photo_charms
    Studio.destroy_all
    @studio = FactoryGirl.create(:studio, :with_session)
    # the offer Email no cart and no friend so it is displayed
    #   in the Suggestions Index view
    FactoryGirl.create(:email,
                       :with_offer,
                       my_studio_session: @studio.sessions.first)
  end

  def create_charms
    ['angel_wing_charm.jpeg',
     'camera_charm.jpeg'].each do |file|
      FactoryGirl.create(:piece, dir: 'charms', file: file)
    end
  end

  def create_photo_charms
    ['evalina_charm.png',
     'harper_charm.png'].each do |file|
      FactoryGirl.create(:piece, dir: 'photo_charms', file: file)
    end
  end

end
