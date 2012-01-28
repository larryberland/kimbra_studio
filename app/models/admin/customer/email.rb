class PickList

  def initialize
    @list = []
  end

  def add(portrait)
    @list << {:portrait => portrait, :used => false}
  end

  def portraits_by_parts(number_of_parts)
    picture_list = []
    one          = @list.select { |entry| (entry[:used] == false) and (entry[:portrait].faces.size == number_of_parts) }
    entry = one.first if one.present?
    if entry
      entry[:portrait].faces.each do |face|
        picture_list << {:portrait => entry[:portrait], :face => face}
      end
      entry[:used] = true
    else
      # going to have to use more than one portrait
      @list.each do |entry|
        if entry[:used] != true

          if entry[:portrait].faces and entry[:portrait].faces.size > 0
            entry[:portrait].faces.each do |face|
              picture_list << {:portrait => entry[:portrait], :face => face}
              break if picture_list.size >= number_of_parts
            end
          else
            picture_list << {:portrait => entry[:portrait]}
          end
          entry[:used] = true # set portrait used

          break if picture_list.size >= number_of_parts

        end
      end
    end
    if picture_list.size < number_of_parts
      # going to have to re-run the list and use a portrait that
      #  may have already been used

      # first pass only use portraits with 1 or no faces
      @list.select { |e| e[:portrait].faces.size < 2 }.each do |entry|
        picture_list << {:portrait => entry[:portrait]}
        break if picture_list.size >= number_of_parts
      end

      # second pass use anything we got as a single picture only
      @list.each do |entry|
        picture_list << {:portrait => entry[:portrait]}
        break if picture_list.size >= number_of_parts
      end if picture_list.size < number_of_parts

    end
    picture_list
  end
end

class Admin::Customer::Email < ActiveRecord::Base
  attr_accessible :description

  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => 'my_studio_session_id'
  has_many :offers, :class_name => 'Admin::Customer::Offer', :dependent => :destroy

  scope :by_session, lambda { |studio_session_id| where('my_studio_session_id = ?', studio_session_id) }

  before_save :set_message

  def self.generate(studio_session)
    email                   = Admin::Customer::Email.new
    email.my_studio_session = studio_session
    piece_pick_list         = [0]
    portrait_pick_list      = PickList.new
    studio_session.portraits.each { |p| portrait_pick_list.add(p) }
    offers             = studio_session.portraits.collect do |portrait|
      piece = Admin::Merchandise::Piece.pick(piece_pick_list).first
      piece_pick_list << piece.id
      photo_parts   = piece.parts.select { |part| part.photo? }
      portrait_list = portrait_pick_list.portraits_by_parts(photo_parts.size)
      Admin::Customer::Offer.generate(email, portrait_list, piece)
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
