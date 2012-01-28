class Admin::Customer::Offer < ActiveRecord::Base

  attr_accessible :image, :remote_image_url,
                  :name, :email, :portrait, :piece, :description,
                  :custom_layout, :portrait_parts_list

  attr_accessor :portrait_parts_list
  mount_uploader :image, ImageUploader                          # the final custom kimbra piece

  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece' # kimbra piece
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'     # Studio session Portrait
  belongs_to :email, :class_name => 'Admin::Customer::Email'

  has_many :items, :class_name => 'Admin::Customer::Item'       # Items that make up the custom piece

  before_create :piece_create_default
  before_save :piece_default

  def self.generate(email, portrait_list, piece)
    offer = Admin::Customer::Offer.create(:email               => email,
                                          :portrait            => portrait_list.first[:portrait],
                                          :piece               => piece,
                                          :portrait_parts_list => portrait_list)
    offer.assemble(piece)
    offer.save
    offer.send(:dump_custom)
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

  def kimbra_parts(merchandise_piece)
    @kimbra_parts      ||= merchandise_piece.parts
    @kimbra_part_index = -1
    @kimbra_parts
  end

  def kimbra_part?
    (@kimbra_part_index + 1) < @kimbra_parts.size
  end

  def kimbra_part_next
    @kimbra_parts[@kimbra_part_index+=1]
  end

  # create a portrait list of photos we have used and not used
  def init_portrait_list
    @portrait_list = PortraitList.new(portrait)
    (portrait.my_studio_session.portraits - [portrait]).each { |portrait| @portrait_list.add(portrait) }
    @portrait_list
  end

  def assemble(merchandise_piece)
    raise "did you forget to assign a piece for this offer?" if merchandise_piece.nil?
    raise "did you forget to assign a studio session for this portrait?" if portrait.my_studio_session.nil?
    raise "did you forget to assign a portrait_parts_list for this offer?" if portrait_parts_list.nil?

    photo_parts     = merchandise_piece.parts.select { |part| part.photo? }
    non_photo_parts = merchandise_piece.parts - photo_parts

    non_photo_parts.each do |part|
      self.items << Admin::Customer::Item.assemble_no_photo(self, part)
    end

    raise "piece=>#{merchandise_piece.name} the portrait_parts_list does not match, expected #{photo_parts.size} got #{portrait_parts_list.size}" if portrait_parts_list.size != photo_parts.size

    photo_parts.each_with_index do |part, index|
      self.items << Admin::Customer::Item.assemble_portrait(self, part, portrait_parts_list[index])
    end

    create_custom_image # create a composite of all the items
    self
  end

  # span text for Offer
  def to_image_span
    text = name.to_s
    text = piece.to_image_span if piece.present?
    text = 'Offer' if text.blank?
    text
  end

  private

  def piece_create_default
    if piece
      self.description   = piece.short_description
      self.name          = piece.to_offer_name
      self.custom_layout = piece.custom_layout
    end
  end

  def piece_default
    if piece
      self.description = piece.short_description if description.nil?
      self.name = piece.to_offer_name if name.nil?
    end
  end

  def draw_by_order
    w = []
    h = []
    items.each do |item|
      h << item.part.piece_layout.h
      w << item.part.piece_layout.w
    end
    height       = h.max
    width        = w.sum
    custom_piece = image_new(width, height)
    items.each_with_index do |item, index|
      custom_piece = item.draw_piece_with_custom(custom_piece)
    end
    p = Tempfile.new(["offer_#{id}", '.jpg'])
    custom_piece.write(p.path)
    set_from_file(image, p.path)
    true
  end

  def draw_by_composite
    custom_piece = piece.get_image
    items.each_with_index do |item, index|
      custom_piece = item.draw_piece(custom_piece)
      custom_piece.write("public/kmagick/custom_offer_#{id}_index_#{index}.jpeg")
    end
    p = Tempfile.new(["offer_#{id}", 'jpg'])
    custom_piece.write(p.path)
    set_from_file(image, p.path)
    true
  end

  def create_custom_image
    send("draw_by_#{custom_layout}")
  end

  def dump_custom
    if Rails.env.development? and image_url
      dump('custom', Magick::Image.read(image_url).first)
    end
  end

end
