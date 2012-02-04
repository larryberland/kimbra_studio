require 'behavior/leota_collection'
class PortraitStrategy

  include LeotaCollection

  def initialize(my_studio_session)
    raise "no portraits in session=>#{my_studio_session.inspect}" if my_studio_session.portraits.nil?
    @list = my_studio_session.portraits.collect do |portrait|
      {:portrait => portrait, :used => false}
    end
  end

  def portraits_by_parts(merchandise_piece)
    init_strategy(merchandise_piece)

    if respond_to?(strategy_method)
      send(strategy_method)
    else
      default_strategy
    end
    @picture_list
  end

  private

  def init_photo_parts
    @max_parts         = @piece.photo_parts.size
    @photo_parts       = @piece.photo_parts
    @photo_parts_index = -1
  end

  def next_photo_part
    @photo_parts_index += 1
    @photo_parts[@photo_parts_index]
  end

  def init_strategy(piece)
    @picture_list    = []
    @strategy_method = nil
    @piece           = piece
    init_photo_parts
  end

  def strategy_method
    @strategy_method ||= "#{@piece.name.downcase.gsub(' ', '_')}_strategy"
    @strategy_method
  end

  def default_strategy
    # see if there is a single portrait that matches the limit of photo_parts we need
    unused_list =  match_faces_to_parts(limit)
    entry = unused_list.first if unused_list.present?
    if entry
      add_faces(entry)
    else
      # going to have to use more than one portrait

      previously_used = @list.select{|l|l[:used] == true}

      unused_list = match_any_face
      unused_list.each do |entry|
        add_faces(entry)
        break if limit?
      end if unused_list.present?

      unless limit?
        unused_list = match_no_faces
        unused_list.each do |entry|
          add_portrait(entry)
          break if limit?
        end if unused_list.present?
      end

      unless limit?
        previously_used.each do |entry|
          if (entry[:portrait].faces.size.to_i > 0)
            add_faces(entry)
          else
            add_portrait(entry)
          end
          break if limit?
        end
      end
    end

  end

  def to_picture_list(portrait, face=nil)
    {:portrait => portrait, :face => face, :photo_part => next_photo_part}
  end

  def limit
    @max_parts
  end

  def limit?
    @picture_list.size >= limit
  end

  def add_portrait(entry)
    entry[:used] = true if @max_parts < 2
    @picture_list << to_picture_list(entry[:portrait])
  end

  def add_face(portrait, face)
    @picture_list << to_picture_list(portrait, face)
  end

  def add_faces(entry)
    entry[:used] = true if @max_parts < 2
    entry[:portrait].faces.each do |face|
      add_face(entry[:portrait], face)
      break if limit?
    end
  end

  # return a list of entries where the number of faces in portrait match number_of_parts
  def match_faces_to_parts(number_of_parts, used=false)
    @list.select { |entry| (entry[:used] == used) and (entry[:portrait].faces.size == number_of_parts) }
  end

  def match_any_face(used=false)
    @list.select { |entry| (entry[:used] == used) and (entry[:portrait].faces.size.to_i > 0) }
  end

  def match_no_faces(used=false)
    @list.select { |entry| (entry[:used] == used) and (entry[:portrait].faces.size.to_i == 0) }
  end

  def dump_list
    @list.each do |entry|
      puts "used=>#{entry[:used]} faces=>#{entry[:portrait].faces.size} portrait=>#{entry[:portrait].id}"
    end
  end
end