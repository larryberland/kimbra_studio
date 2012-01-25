class Admin::Customer::Offer < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :name, :email, :portrait, :piece, :description
  mount_uploader :image, ImageUploader                          # the final custom kimbra piece

  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece' # kimbra piece
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'     # Studio session Portrait
  belongs_to :email, :class_name => 'Admin::Customer::Email'

  has_many :items, :class_name => 'Admin::Customer::Item'       # Items that make up the custom piece

  before_save :piece_default

  def self.path(dir)
    p = Rails.root.join('public','emails','offers', dir)
    p.mkpath unless File.exists?(p.to_s)
    p
  end

  def self.generate(email, portrait, piece)

    offer = Admin::Customer::Offer.create(:email    => email,
                                          :portrait => portrait,
                                          :piece    => piece)

    puts "offer assemble portrait=>#{offer.portrait.id}"
    offer.assemble(piece)

    # TODO: this image should be a composite
    #       of all the parts of this piece put together
    # copy the existing for now

    if piece.image.present?
      puts "offer get piece=>#{piece.image_url}"
      offer.image = piece.image.file # copy the existing for now
    else
      puts "offer get home=>#{home.jpg}"
      offer.image = File.open(Rails.root.join('app', 'assets', 'images', 'home.png').to_s)
    end

    offer.write_image_identifier
    # TODO: end
    offer.save

    if Rails.env.development?
      puts "offer image=>#{offer.image_url}"
      if offer.image_url.present?
        Magick::Image.read(offer.image_url.to_s).first.write(path('custom').join("offer_#{offer.id}_piece_#{piece.id}_portrait_#{portrait.id}.jpg").to_s)
      end
    end
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
    @kimbra_parts ||= merchandise_piece.parts
    @kimbra_part_index = -1
    @kimbra_parts
  end

  def kimbra_part?
    (@kimbra_part_index + 1) < @kimbra_parts.size
  end

  def kimbra_part_next
    @kimbra_parts[@kimbra_part_index+=1]
  end

  def assemble(merchandise_piece)
    raise "did you forget to assign a piece for this offer?" if merchandise_piece.nil?
    raise "did you forget to assign a studio session for this portrait?" if portrait.my_studio_session.nil?

    if kimbra_parts(merchandise_piece)

      if merchandise_piece.parts.size > 1

        portrait_list = [portrait] + (portrait.my_studio_session.portraits - [portrait])

        portrait_list.each do |picture|

          puts "  picture id=>#{picture.id} for #{merchandise_piece.name}"
          if picture.faces.present?
            picture.faces.each do |face|
              # create an item with this face
              self.items << Admin::Customer::Item.assemble_portrait_face(self, kimbra_part_next, picture, face)
              break unless kimbra_part?
            end
          else
            self.items << Admin::Customer::Item.assemble_portrait(self, kimbra_part_next, picture)
          end
          break unless kimbra_part?
        end
      else
        # only 1 Kimbra part so use any face info otherwise use whole portrait
        if portrait.faces.present?
          if portrait.faces.size == 1
            # create an item with this face
            self.items << Admin::Customer::Item.assemble_portrait_face(self, kimbra_part_next, portrait, portrait.faces.first)
          else
            self.items << Admin::Customer::Item.assemble_portrait(self, kimbra_part_next, portrait)
          end
        else
          self.items << Admin::Customer::Item.assemble_portrait(self, kimbra_part_next, portrait)
        end
      end
    else
      Rails.logger.info("WARN: missing parts for merchandise::piece=>#{merchandise_piece.inspect}")
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

  private

  def piece_default
    if piece
      self.description = piece.short_description if description.nil?
      self.name = piece.to_offer_name if name.nil?
    end
  end

  def create_custom_image
    w = 0
    h = 0
    list = []
    items.each do |item|
      list << [w, 0]
      w += item.width.to_i
      h = item.height.to_i if item.height.to_i > h
    end
    puts "list=>#{list.inspect}"
  end
end
