class Admin::Customer::Email < ActiveRecord::Base

  attr_accessible :description, :message, :generated_at, :sent_at, :active, :tracking,
                  :my_studio_session

  before_save :set_message

  belongs_to :my_studio_session, class_name: 'MyStudio::Session', foreign_key: 'my_studio_session_id'
  has_many :offers, class_name: 'Admin::Customer::Offer', dependent: :destroy, order: 'id DESC'
  has_many :carts, class_name: 'Shopping::Cart'

  scope :by_session, lambda { |studio_session_id| where('my_studio_session_id = ?', studio_session_id) }

  after_initialize do |email|
    email.tracking = UUID.random_tracking_number
  end

  # So that tracking number will be the id in params.
  def to_param
    tracking
  end

  # Typically called as a rake task from the cron hourly.
  def self.send_offer_emails
    sent = 0
    Admin::Customer::Email.where('sent_at is NULL and active = ?', true).each do |email|
      email.send_offers unless Unsubscribe.exists?(email: email.my_studio_session.client.email)
      puts "Sent daily offer for #{Date.today} to #{}"
      sent += 1
    end
    puts "Prepared #{sent} offer emails to be sent."
  end

  def self.test_piece(piece)
    email = Admin::Customer::Email.new(my_studio_session: MyStudio::Session.first)

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

  def self.generate(studio_session_id)
    studio_session = MyStudio::Session(studio_session_id)
    email = Admin::Customer::Email.new(my_studio_session: studio_session)

    # setup merchandise piece pick_list strategy

    # for testing each category piece just set the categories array index below
    # Categories
    categories = %w(Necklaces Bracelets Charms Rings ).collect { |e| "Photo #{e}" }
    categories << 'Holiday'
    # Photo Bracelets
    # Photo Necklaces
    #piece_strategy_list = PieceStrategy.new.pick_category(categories[4]) # testing
    # end of test

    piece_strategy_list = PieceStrategy.new(email).pick_pieces

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

  def previous_emails
    raise "did you forget to set my_studio_session" if my_studio_session.nil?
    @previous_emails = my_studio_session.emails if @previous_emails.nil?
    @previous_emails
  end

  # list of all previous offers sent to the studio_session's clients
  def previous_offers
    raise "did you forget to set my_studio_session" if my_studio_session.nil?
    my_studio_session.previous_offers
  end

  def sort_session_name
    my_studio_session.name
  end

  def send_offers
    ClientMailer.delay.send_offers(self.id)
    update_attributes(:sent_at => Time.now.to_s(:db))
  end

  private #================================================

  def set_message
    self.message = I18n.translate(:email_message, :name => my_studio_session.client.name.titleize) unless message
  end


end