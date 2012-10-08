class Admin::Customer::Email < ActiveRecord::Base

  attr_accessible :description, :message, :generated_at, :sent_at, :active, :tracking,
                  :my_studio_session

  belongs_to :my_studio_session, class_name: 'MyStudio::Session', foreign_key: 'my_studio_session_id'
  has_many :offers, class_name: 'Admin::Customer::Offer', dependent: :destroy, order: 'id DESC'
  has_many :carts, class_name: 'Shopping::Cart'

  # active_model callbacks
  before_save :set_message

  after_initialize do |email|
    email.tracking = UUID.random_tracking_number if email.tracking.nil?
  end

  scope :by_session, lambda { |studio_session_id| where('my_studio_session_id = ?', studio_session_id) }

  scope :unsent, where('sent_at is NULL and active = ?', true)

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
    portrait_pick_list  = studio_session.portrait_list

    order_by_number_of_parts = piece_strategy_list.sort_by { |piece| piece.photo_parts.size.to_i }.reverse

    idx    = 0
    offers = order_by_number_of_parts.collect do |piece|
      strategy_picture_list = []
      piece.photo_parts.each do |part|
        strategy_picture_list << {portrait:   portrait_pick_list[idx],
                                  photo_part: part,
                                  face:       nil} # temp for now will remove
        idx += 1
        idx = 0 if idx >= portrait_pick_list.size
      end
      strategy_picture_list = portrait_strategy_list.portraits_by_parts(piece)
      Admin::Customer::Offer.generate(email, piece, strategy_picture_list)
    end

    email.offers       = offers
    email.generated_at = Time.now
    email.save
    puts "built email=>#{email.id} offer=>#{email.offer.id} item=>#{email.offer.item.id}"
    email
  end

  # Entry point to Generate the Offers for an Email to our customer
  def self.generate(studio_session_id)
    studio_session     = MyStudio::Session.find(studio_session_id)
    email              = Admin::Customer::Email.new(my_studio_session: studio_session)

    # pick portraits that are only set active
    portrait_pick_list = studio_session.portrait_list
    raise "photo session needs at least 3 active portraits count:#{portrait_pick_list.count}" unless studio_session.email_ready?

    # setup merchandise piece pick_list strategy

    # for testing each category piece just set the categories array index below
    # Categories
    categories = %w(Necklaces Bracelets Charms Rings ).collect { |e| "Photo #{e}" }
    categories << 'Holiday'
    # Photo Bracelets
    # Photo Necklaces
    if Rails.env.development?
      # This will generate an Email with an offer from every piece in a specific category
      #  just enter in the Category you want to be generated
      #  (ie categories[2]  will do all charms)
      piece_strategy_list = PieceStrategy.new(email).pick_category(categories[0])
    else

      # pick some pieces to send
      piece_strategy_list = PieceStrategy.new(email).pick_pieces
    end
    Rails.logger.info("piece_strategy_list:#{piece_strategy_list.inspect}")

    # arrange the order we are going to create the offers based on the number of parts for each piece
    #  (ie bracelets are done first then single charms)
    order_by_number_of_parts = piece_strategy_list.sort_by { |piece| piece.photo_parts.size.to_i }.reverse

    # lets go create and assemble all the pieces
    idx                      = -1
    offers                   = order_by_number_of_parts.collect do |piece|

      strategy_picture_list = piece.photo_parts.each.collect do |part|
        idx += 1
        idx = 0 if idx >= portrait_pick_list.size
        # suggest a portrait to be used for each of the pieces  parts that require a photo
        {portrait: portrait_pick_list[idx], photo_part: part, face: nil} # temp for now will remove
      end

      # create the offer for this kimbra piece with the suggested (part and picture) for each Offer
      offer                 = Admin::Customer::Offer.generate(email, piece, strategy_picture_list)
      offer
    end

    email.offers       = offers
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
  end

  def in_send_offers_queue?
    # Look for a send_offer job waiting.
    jobs = DelayedJob.where(" handler like '%:send_offers%' ")
    jobs.detect { |job| YAML.load(job.handler).args.include? self.id }.present?
  end

  private #================================================

  def set_message
    self.message = I18n.translate(:email_message, :name => my_studio_session.client.name.titleize) unless message
  end

end