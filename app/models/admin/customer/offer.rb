class Admin::Customer::Offer < ActiveRecord::Base

  attr_accessible :image, :remote_image_url,
                  :image_front, :remote_image_front_url,
                  :image_back, :remote_image_back_url,
                  :name, :email, :piece, :description,
                  :custom_layout, :portrait_parts_list

  attr_accessor :portrait_parts_list                            # parts list having portraits assigned to which part

  mount_uploader :image, ImageUploader                          # the final custom kimbra piece
  mount_uploader :image_front, ImageUploader                    # the front side of the final custom kimbra piece
  mount_uploader :image_back, ImageUploader                     # the back side of the final custom kimbra piece

  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece' # kimbra piece
  belongs_to :email, :class_name => 'Admin::Customer::Email'

  has_many :items, :class_name => 'Admin::Customer::Item'       # Items that make up the custom piece

  before_create :piece_create_default
  before_save :piece_default

  # portrait_parts_list
  #   array => {:photo_parts => merchandise_part to use,
  #             :portrait => portrait to use for this part,
  #             :face => face within this portrait to use
  def self.generate(email, piece, portrait_parts_list)
    offer = Admin::Customer::Offer.create(:email               => email,
                                          :piece               => piece,
                                          :portrait_parts_list => portrait_parts_list)
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

  def back
    image_back
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

  def draw_by_order(front_side=true)
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
      custom_piece = item.draw_piece_with_custom(custom_piece, front_side)
    end
    t_front_or_back = Tempfile.new(["offer_#{id}", '.jpg'])
    custom_piece.write(t_front_or_back.path)
    set_from_file(front_side ? image_front : image_back, t_front_or_back.path)
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
    set_from_file(front ? image_front : image_back, t_front_or_back.path)
    t_front_or_back
  end

  def baby_got_back
    list = items.select { |item| item.back.present? }
    list.size > 0 ? true : false
  end

  def create_custom_image
    t_front = send("draw_by_#{custom_layout}", front=true)
    set_from_file(image, t_front.path)
    if baby_got_back
      puts "has back side"
      send("draw_by_#{custom_layout}", front=false)
    else
      puts "no back side"
    end
  end

  def dump_custom
    if Rails.env.development? and image_url
      dump('custom', Magick::Image.read(image_url).first)
    end
  end

end
