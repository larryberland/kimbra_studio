class Admin::Customer::Email < ActiveRecord::Base
  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => 'my_studio_session_id'
  has_many :offers, :class_name => 'Admin::Customer::Offer', :dependent => :destroy

  def self.generate(studio_session)
    email = Admin::Customer::Email.new
    email.my_studio_session = studio_session
    piece_pick_list = [0]
    list = studio_session.portraits.collect do |portrait|
      offer = Admin::Customer::Offer.generate(email, portrait)
      offer.pieceilize(Admin::Merchandise::Piece.pick(piece_pick_list).first)
      piece_pick_list << offer.piece.id
      offer
    end
    email.offers = list
    email.save
    email
  end
end
