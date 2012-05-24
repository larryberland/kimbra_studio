class Admin::Customer::Offer < ActiveRecord::Base

  attr_accessible :image, :remote_image_url,
                  :image_front, :remote_image_front_url,
                  :image_back, :remote_image_back_url,
                  :name, :email, :piece, :description,
                  :custom_layout, :portrait_parts_list,
                  :tracking

  attr_accessor :portrait_parts_list # parts list having portraits assigned to which part
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  mount_uploader :image, ImageUploader # the final custom kimbra piece
  mount_uploader :image_front, ImageUploader # the front side of the final custom kimbra piece
  mount_uploader :image_back, ImageUploader # the back side of the final custom kimbra piece

  before_create :piece_create_default_and_tracking
  before_save :piece_default
  after_update :check_width

  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece' # kimbra piece
  belongs_to :email, :class_name => 'Admin::Customer::Email'

  has_many :items, :class_name => 'Admin::Customer::Item' # Items that make up the custom piece

  has_one :shopping_item, :class_name => 'Shopping::Item'

  # So that tracking number will be the id in params.
  def to_param
    tracking
  end

  def self.test_offer(options)
    options[:email] ||= Admin::Customer::Email.first
    options[:piece] ||= Admin::Merchandise::Piece.first
    options[:portrait_parts_list]
  end

  # portrait_parts_list
  #   array => {:photo_parts => merchandise_part to use,
  #             :portrait => portrait to use for this part,
  #             :face => face within this portrait to use
  def self.generate(email, piece, portrait_parts_list)
    tracking = UUID.random_tracking_number
    offer = Admin::Customer::Offer.create(
        :tracking => tracking,
        :email => email,
        :piece => piece,
        :portrait_parts_list => portrait_parts_list)
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
  #     create item with portrait as function of face
  #
  #   Piece has multiple parts
  #     Portrait
  #       has no faces:
  #         create item with portrait resize
  #       has one face:
  #         create item for this face centered
  #       has multiple faces:
  #         create item for each face centered
  #

  def assemble(merchandise_piece)
    raise "did you forget to assign a piece for this offer?" if merchandise_piece.nil?
    raise "did you forget to assign a portrait_parts_list for this offer?" if portrait_parts_list.nil?

    # add an item for every non_photo part
    merchandise_piece.non_photo_parts.each do |part|
      portrait_parts_list << [{:photo_part => part}] # bad choice on name
                                                     # this is really a non_photo_part
    end

    # add an item for every photo_part we have
    portrait_parts_list.each do |item_options|
      self.items << Admin::Customer::Item.assemble_side(self, item_options)
    end

    # create a composite of all the items
    create_custom_image
    self
  end

  # span text for Offer
  def to_image_span
    text = name.to_s
    text = piece.to_image_span if piece.present?
    text = 'Offer' if text.blank?
    text
  end

  def back
    image_back
  end

  def on_layout_change
    # need to redraw the offer image
    create_custom_image
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

  def update_front_side(item)
    # need to rebuild each item in order to build the custom piece

    #custom_piece = item.draw_piece_with_custom(custom_piece, front_side=true)
    t_front_or_back = Tempfile.new(["offer_#{id}", '.jpg'])
    #puts "    custom_piece #{custom_piece.columns}x#{custom_piece.rows}"
    #image_front.store_file!(item.front.image_custom.path)
    #image.store_file!(item.front.image_custom.path)
    #image.recreate_versions!
    create_custom_image
  end

  def update_back_side

  end

  private #===========================================================================

  def piece_create_default_and_tracking
    if piece
      self.description = piece.short_description
      self.name = piece.to_offer_name
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
    puts "  draw_by_order front=>#{front_side}"
    w = []
    h = []
    items.each do |item|
      h << item.part.piece_layout.h
      w << item.part.piece_layout.w
    end
    height = h.max
    width = w.sum
    puts "    size=>#{width}x#{height}"
    custom_piece = image_new(width, height)
    items.each_with_index do |item, index|
      custom_piece = item.draw_piece_with_custom(custom_piece, front_side)
    end
    t_front_or_back = Tempfile.new(["offer_#{id}", '.jpg'])
    puts "    custom_piece #{custom_piece.columns}x#{custom_piece.rows}"
    custom_piece.write(t_front_or_back.path)
    i = front_side ? image_front : image_back
    i.store_file!(t_front_or_back.path)
    puts "    Store custom piece finished"
    puts ""
    t_front_or_back
  end

  def draw_by_composite(front=true)
    custom_piece = piece.get_image
    items.each_with_index do |item, index|
      custom_piece = item.draw_piece(custom_piece, front)
      custom_piece.write("public/kmagick/custom_offer_#{id}_index_#{index}.jpeg")
    end
    t_front_or_back = Tempfile.new(["offer_#{id}", 'jpg'])
    custom_piece.write(t_front_or_back.path)
    i = front ? image_front : image_back
    i.store_file!(t_front_or_back.path)
    t_front_or_back
  end

  def baby_got_back
    list = items.select { |item| item.back.present? }
    list.size > 0 ? true : false
  end

  def create_custom_image
    puts ""
    puts "create_custom_image #{self}"
    puts "Offer=>#{piece.name} custom_layout=>#{custom_layout}"
    t_front = send("draw_by_#{custom_layout}", front=true)
    puts "front=>#{t_front.path}"
    image.store_file!(t_front.path)
    puts "#{self} image stored."
    puts ""
    if baby_got_back
      puts "has back side"
      send("draw_by_#{custom_layout}", front=false)
    else
      puts "no back side"
    end
    dump_custom
    save
  end

  def dump_custom
    if Rails.env.development? and image_url
      dump('custom', image.to_image)
    end
  end

  def check_width
    puts "#{self} size=>#{width}x#{height}"
  end

end