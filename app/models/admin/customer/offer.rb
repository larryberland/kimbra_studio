class Admin::Customer::Offer < ActiveRecord::Base

  mount_uploader :image, ImageUploader                          # the final custom kimbra piece
  mount_uploader :image_front, ImageUploader                    # the front side of the final custom kimbra piece
  mount_uploader :image_back, ImageUploader                     # the back side of the final custom kimbra piece

  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece' # kimbra piece
  belongs_to :email, :class_name => 'Admin::Customer::Email'

  has_many :items, :class_name => 'Admin::Customer::Item'       # Items that make up the custom piece

  has_one :shopping_item, :class_name => 'Shopping::Item'

  attr_accessible :image, :remote_image_url,
                  :image_front, :remote_image_front_url,
                  :image_back, :remote_image_back_url,
                  :name, :email, :description,
                  :piece, :custom_layout, :item_options_list,
                  :piece, :piece_id,
                  :tracking, :active, :activation_code, :frozen,
                  :portrait_id

  # parts list having portraits assigned to which part
  attr_accessor :item_options_list, :portrait_id, :image_front_cache

  # active_model callbacks
  before_create :piece_create_default_and_tracking
  before_save :piece_default
  after_update :check_width

  # So that tracking number will be the id in params.
  def to_param
    tracking
  end

  def self.test_offer(options)
    options[:email] ||= Admin::Customer::Email.first
    options[:piece] ||= Admin::Merchandise::Piece.first
    options[:item_options_list]
  end

  # Create a item_options_list array that is used by the assemble
  #   so it knows which portrait can be assigned to all the pieces
  #   photo_parts
  #
  # The Email is sending in which part should get this photo described
  #   in the item_options_list Array of hashes
  #   item_options_list
  #     array => {:photo_part => merchandise_part to use,
  #               :portrait => portrait to use for this part}
  def self.generate(email, piece, item_options_list)
    list = item_options_list
    list = [item_options_list] if item_options_list.kind_of?(Hash)
    list  ||= [] # if Email has no item_options suggestions make sure we have at least the array
    offer = Admin::Customer::Offer.create(
        tracking:          UUID.random_tracking_number,
        email:             email,
        piece:             piece, # parent merchandise.piece
        item_options_list: list)
    offer.assemble(piece)
    offer
  end

  # generate an offer directly from a kimbra piece
  # NOTE: So far these are all non-photo charms or chains
  def self.generate_from_piece(email, piece_id)
    piece = Admin::Merchandise::Piece.find(piece_id)
    offer = Admin::Customer::Offer.create(
        tracking:          UUID.random_tracking_number,
        email:             email,
        piece:             piece, # parent merchandise.piece
        item_options_list: [])
    offer.assemble(piece)
    offer
  end

  # Using a Kimbra Piece made up of Kimbra Parts we create
  #  a Custom Offer with custom items which are mapped one to one
  #  with the Kimbra parts.
  #
  # assemble all the Kimbra parts turning them into Offer Items.
  # Strategy
  #
  #   Piece has a single part
  #     create item with portrait
  #
  #   Piece has multiple parts
  #     Portrait
  #      create item with portrait resize
  def assemble(merchandise_piece)
    raise "did you forget to assign a piece for this offer?" if merchandise_piece.nil?
    raise "did you forget to assign a item_options_list for this offer?" if item_options_list.nil?
    raise "did you forget to convert your item_options_list into an array?" unless item_options_list.kind_of?(Array)

    # create all of our non_photo items and store them in our
    # item_options_list. LDB: sure seems like this variable should be called part_items_list

    # for every non_photo part defined in the merchandise.piece
    #   create an offer item representing that non_photo part
    #   and add it out item_options_list for this offer.
    merchandise_piece.non_photo_parts.each do |part|
      item_options_list << {photo_part: part, portrait: nil}
    end

    # Turn our requested item_options_list into the Offer
    #   items array
    Rails.logger.info("offer\nitem_options_list:#{item_options_list.flatten.inspect}")
    item_options_list.flatten.each do |item_options|
      self.items << Admin::Customer::Item.assemble_side(self, item_options)
    end

    # create a composite of all the items
    create_images

    self
  end

  # reassemble this piece using the current piece_id and portrait_id
  #   sent in from the form
  def on_create
    on_update(-1)
  end

  # Using the existing offer information, going to reassemble
  #  this offer with the new kimbra merchandise piece
  def on_update(previous_piece_id)

    new_piece    = previous_piece_id != piece_id
    new_portrait = portrait_id.to_i > 0

    if (new_piece or new_portrait)

      # grab any existing portrait info from items
      current_portraits = []

      if (new_portrait)

        current_portraits << MyStudio::Portrait.find_by_id(portrait_id)

      end

      # pull out the portraits this offer is currently using
      items.each do |item|
        item.item_sides.each do |side|
          current_portraits << side.portrait
        end
      end

      # remove any old items we had
      items.destroy_all if items.present?

      # setup our item options
      item_options_list = []

      # for every non_photo part defined in the merchandise.piece
      #   create an offer item representing that non_photo part
      #   and add it out item_options_list for this offer.
      piece.non_photo_parts.each do |part|
        item_options_list << {photo_part: part, portrait: nil}
      end

      piece.photo_parts.each_with_index do |part, index|
        options = {photo_part: part}
        if (index < current_portraits.size)
          options[:portrait] = current_portraits[index]
        else
          options[:portrait] = email.my_studio_session.portraits.first
        end
        item_options_list << options
      end

      item_options_list.flatten.each do |item_options|
        self.items << Admin::Customer::Item.assemble_side(self, item_options)
      end

      # LDB:? NOTE
      # this is a before_create right now and i am going
      #  to leave it there until we know we want to do this on
      #  updates as well
      piece_create_default_and_tracking

      # create a composite of all the items
      create_images

      if (errors.messages)
        Rails.logger.warn "CHALLENGE:: offer save errors:#{errors.full_messages}"
      end
    end

    self
  end

  # this allows carrier_wave to recreate_versions whenever we
  #  manipulate the image items in fog and need to recreate
  #  out different versions
  def self.fog_buster(offer_id)
    offer = find(offer_id)

    offer.image_front.cache_stored_file!
    offer.image_front.retrieve_from_cache!(offer.image_front.cache_name)
    offer.image_front.recreate_versions!

    if (offer.image_back.present?)
      offer.image_back.cache_stored_file!
      offer.image_back.retrieve_from_cache!(offer.image_back.cache_name)
      offer.image_back.recreate_versions!
    end

    offer.image.cache_stored_file!
    offer.image.retrieve_from_cache!(offer.image.cache_name)
    offer.image.recreate_versions!

    offer.save!
    offer
  end

  # list of portrait's used by all items in this offer
  def item_portrait_list
    items.each.collect { |item| item.portrait_list }.compact if items.present?
  end

  # span text for Offer
  def to_image_span
    text = name.to_s
    text = piece.to_image_span if piece.present?
    text = 'Offer' if text.blank?
    text
  end

          # return all portraits that make up this offer
  def portrait_list
    items.collect { |item| item.portrait_list }.flatten.compact
  end

  def back
    image_back
  end

  def on_layout_change
    # need to redraw the offer image
    create_images
  end

  def price
    v = if piece
          if piece.price
            piece.price
          else
            "KBS::Missing price for piece=>#{piece.inspect}"
          end
        else
          "KBS::Missing piece info for offer=>#{self.inspect}"
        end
    if v.kind_of? String
      # tell jim we don't have price data
      Rails.logger.warn(v)
      v = 200.0
    elsif v < 1.0
      v = 200.0
    end
    v
  end

  def portraits
    if email
      if s = email.my_studio_session
        portraits = s.portraits
      end
    end
    portraits ||= []
    portraits
  end

  def has_picture?
    piece.photo_parts.present?
  end

  # Adjusted one of the item.item_sides for this offer
  def update_front_side(item)
    # need to rebuild each item in order to build the custom piece
    create_images
  end

  def update_back_side

  end

  private #===========================================================================

  def piece_create_default_and_tracking
    if piece
      self.description   = piece.short_description
      self.name          = piece.to_offer_name
      self.custom_layout = piece.custom_layout
    end
    self.tracking = UUID.random_tracking_number if tracking.nil?
  end

  def piece_default
    if piece
      self.description = piece.short_description if description.nil?
      self.name = piece.to_offer_name if name.nil?
    end
  end

  # draw each part in a horizontal line
  def draw_by_order(front_side=true)
    # puts "  draw_by_order front=>#{front_side}"
    w = []
    h = []
    # calculate the max width and height of all our
    # items that are making up the complete side
    items.each do |item|
      h << item.part.piece_layout.h
      w << item.part.piece_layout.w
    end
    height       = h.max
    width        = w.sum
    # create the custom piece image that is the maximum size based on
    #   all the individual parts
    custom_piece = image_new(width, height)
    items.each_with_index do |item, index|
      custom_piece = item.draw_piece_with_custom(custom_piece, front_side)
    end
    t_front_or_back = Tempfile.new(["offer_#{id}", '.jpg'])
    puts "    custom_piece #{custom_piece.columns}x#{custom_piece.rows}"
    custom_piece.write(t_front_or_back.path)
    i = front_side ? image_front : image_back

    puts "order before:#{i.inspect}"
    puts "order    url:#{i.url(:thumb)}"
    i.store_file!(t_front_or_back.path)
    puts "order after:#{i.inspect}"
    puts "order   url:#{i.url(:thumb)}"
    # puts "    Store custom piece finished"
    # puts ""
    t_front_or_back
  end

  # Take every items side (either front or back)
  #  and place them onto the piece.get_image
  #  as defined by item_side.part.piece_layout information
  def draw_by_composite(front=true)
    #custom_piece = piece.get_image
    custom_piece = piece.get_image
    #custom_piece = image_transparent(final.columns, final.rows)
    items.each_with_index do |item, index|
      puts "item[#{index}]"
      custom_piece = item.draw_kimbra_piece(custom_piece, front)
    end

    t_front_or_back = Tempfile.new(["offer_#{id}", '.jpg'])

    custom_piece.write(t_front_or_back.path)

    i = front ? image_front : image_back
    raise "#{self}  front=>#{front} bad path=>#{t_front_or_back.path}" unless t_front_or_back.path.present?
    raise "#{self}  front=>#{front} bad path=>#{t_front_or_back.path}" if t_front_or_back.path.blank?
    i.store_file!(t_front_or_back.path)
    dump('custom_item edit', i.to_image)
    t_front_or_back
  end

  def baby_got_back
    list = items.select { |item| item.back.present? }
    list.size > 0 ? true : false
  end

  # creates three images for this offer record
  #  a front side compilation of each item
  #  a back side compilation of each item
  #  a final image with each items portrait placed into the final Kimbra piece
  def create_images
    # draw the front side
    t_front = send("draw_by_#{custom_layout}", front=true)

    # the overall image is just a snapshot of the front side right now
    image.store_file!(t_front.path)

    # draw the back side
    send("draw_by_#{custom_layout}", front=false) if baby_got_back

    # draw all the parts onto our kimbra piece
    #draw_kimbra_custom

    # save our offer record
    save
  end

  def check_width
    puts "#{self} size=>#{width}x#{height}" if Rails.env.test?
  end

end