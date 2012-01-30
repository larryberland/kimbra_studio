class Admin::Customer::Email < ActiveRecord::Base
  attr_accessible :description, :message, :generated_at, :sent_at, :active

  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => 'my_studio_session_id'
  has_many :offers, :class_name => 'Admin::Customer::Offer', :dependent => :destroy

  scope :by_session, lambda { |studio_session_id| where('my_studio_session_id = ?', studio_session_id) }

  before_save :set_message

  def self.generate(studio_session)
    email                   = Admin::Customer::Email.new
    email.my_studio_session = studio_session
    piece_pick_list         = [0]

    # setup portrait pick_list strategy
    portrait_strategy_list  = PortraitStrategy.new(studio_session)

    # generate the merchandise piece list
    number_offers           = [studio_session.portraits.size, 4].min

    # create a Hash of each piece and the number of photo_parts needed
    piece_list              = (0..number_offers).collect do |index|
      piece = Admin::Merchandise::Piece.pick(piece_pick_list).first
      piece_pick_list << piece.id
      piece
    end

    order_by_number_of_parts = piece_list.sort_by { |piece| piece.photo_parts.size.to_i }.reverse

    offers = order_by_number_of_parts.collect do |piece|
      strategy_picture_list = portrait_strategy_list.portraits_by_parts(piece)
      Admin::Customer::Offer.generate(email, piece, strategy_picture_list)
    end

    email.offers       = offers
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
