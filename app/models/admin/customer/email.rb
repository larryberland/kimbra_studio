class Admin::Customer::Email < ActiveRecord::Base

  attr_accessible :description, :message, :generated_at, :sent_at, :active, :tracking

  before_create :set_tracking
  before_save :set_message

  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => 'my_studio_session_id'
  has_many :offers, :class_name => 'Admin::Customer::Offer', :dependent => :destroy
  has_many :carts, :class_name => 'Shopping::Cart'

  scope :by_session, lambda { |studio_session_id| where('my_studio_session_id = ?', studio_session_id) }

  # So that tracking number will be the id in params.
    def to_param
      tracking
    end

  def self.test_piece(piece)
    email = Admin::Customer::Email.new
    tracking = UUID.random_tracking_number
    email.tracking = tracking
    email.my_studio_session = MyStudio::Session.first

    piece_strategy_list = [piece]

    # setup portrait pick_list strategy
    portrait_strategy_list = PortraitStrategy.new(email.my_studio_session)

    order_by_number_of_parts = piece_strategy_list.sort_by { |piece| piece.photo_parts.size.to_i }.reverse

    offers = order_by_number_of_parts.collect do |piece|
      strategy_picture_list = portrait_strategy_list.portraits_by_parts(piece)
      Admin::Customer::Offer.generate(email, piece, strategy_picture_list)
    end

    email.offers = offers
    email.generated_at = Time.now
    email.save
    puts "built email=>#{email.id} offer=>#{email.offer.id} item=>#{email.offer.item.id}"
    email
  end

  def self.generate(studio_session)
    email = Admin::Customer::Email.new

    tracking = UUID.random_tracking_number
    email.tracking = tracking
    email.my_studio_session = studio_session

    # setup merchandise piece pick_list strategy

    # for testing each category piece just set the categories array index below
    # Categories
    categories = %w(Necklaces Bracelets Charms Rings ).collect { |e| "Photo #{e}" }
    categories << 'Holiday'
    # Photo Bracelets
    # Photo Necklaces
    #piece_strategy_list = PieceStrategy.new.pick_category(categories[4]) # testing
    # end of test

    piece_strategy_list = PieceStrategy.new.pick_pieces

    # setup portrait pick_list strategy
    portrait_strategy_list = PortraitStrategy.new(studio_session)

    order_by_number_of_parts = piece_strategy_list.sort_by { |piece| piece.photo_parts.size.to_i }.reverse

    offers = order_by_number_of_parts.collect do |piece|
      strategy_picture_list = portrait_strategy_list.portraits_by_parts(piece)
      offer = Admin::Customer::Offer.generate(email, piece, strategy_picture_list)
      offer
    end

    email.offers = offers
    email.generated_at = Time.now
    email.save
    email
  end

  def sort_session_name
    my_studio_session.name
  end

  def send_offers
    ClientMailer.delay.send_offers(self)
    update_attributes(:sent_at => Time.now.to_s(:db))
  end

  private #================================================

  def set_message
    self.message = I18n.translate(:email_message, :name => my_studio_session.client.name.titleize) unless message
  end

  def set_tracking
    self.tracking = UUID.random_tracking_number unless tracking
  end

end