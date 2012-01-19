class Admin::Customer::Email < ActiveRecord::Base
  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => 'my_studio_session_id'
  has_many :offers, :class_name => 'Admin::Customer::Offer', :dependent => :destroy

  scope :by_session, lambda { |studio_session_id| where('my_studio_session_id = ?', studio_session_id) }

  def self.generate(studio_session)
    email = Admin::Customer::Email.new
    email.my_studio_session = studio_session
    piece_pick_list = [0]
    list = studio_session.portraits.collect do |portrait|
      offer = Admin::Customer::Offer.generate(email, portrait)
      offer.pieceilize(Admin::Merchandise::Piece.pick(piece_pick_list).first)
      offer.assemble
      piece_pick_list << offer.piece.id
      offer
    end
    email.offers = list
    email.save
    email.generated_at = Time.now
    email
  end

  def sort_session_name
    my_studio_session.name
  end
end
