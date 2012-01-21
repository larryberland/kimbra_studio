class Admin::Customer::Email < ActiveRecord::Base
  attr_accessible :description

  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => 'my_studio_session_id'
  has_many :offers, :class_name => 'Admin::Customer::Offer', :dependent => :destroy

  scope :by_session, lambda { |studio_session_id| where('my_studio_session_id = ?', studio_session_id) }

  before_save :set_message

  def self.generate(studio_session)
    email = Admin::Customer::Email.new
    email.my_studio_session = studio_session
    piece_pick_list = [0]
    offers = studio_session.portraits.collect do |portrait|
      piece = Admin::Merchandise::Piece.pick(piece_pick_list).first
      puts "pick_list=>#{piece_pick_list.inspect} got=>#{piece.id}"
      piece_pick_list << piece.id
      Admin::Customer::Offer.generate(email, portrait, piece)
    end
    email.offers = offers
    email.generated_at = Time.now
    email.save
    email
  end

  def sort_session_name
    my_studio_session.name
  end

  private

  def set_message
    if message.nil?
      self.message = I18n.translate(:email_message, :name => my_studio_session.client.name.titleize)
    end
  end
end
