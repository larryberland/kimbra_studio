require 'behavior/leota_collection'
class PortraitStrategy

  include LeotaCollection

  def initialize(my_studio_session)
    raise "no portraits in session=>#{my_studio_session.inspect}" if my_studio_session.portraits.nil?
    @list     = my_studio_session.to_strategy_portrait
    # Hash of portrait info grouped_by number of faces for quicker access
    @by_faces = @list.group_by { |r| r[:portrait].faces.size }
    #puts "by_faces keys:#{@by_faces.keys.join(', ')}"
  end

  # select portraits for this merchandise_piece
  def portraits_by_parts(merchandise_piece)
    init_strategy(merchandise_piece)
    if respond_to?(strategy_method)
      send(strategy_method) # we have defined a customized strategy for this piece
    else
      #puts ""
      #puts "begin"
      #@list.each do |entry|
      #  puts " id:#{entry[:portrait].id} used:#{entry[:used]} prev:#{entry[:used_previous]} faces:#{entry[:portrait].faces.size}"
      #end
      default_strategy
    end
    #puts "finish:"

    #@list.each do |entry|
    #  puts " id:#{entry[:portrait].id} used:#{entry[:used]} prev:#{entry[:used_previous]} faces:#{entry[:portrait].faces.size}"
    #end
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

  # customize the way this piece handles the portrait selection process
  #   the customize methods should be in the strategies/behavior modules
  #   (ex. leota_collection_strategy)
  def strategy_method
    @strategy_method ||= "#{@piece.name.downcase.gsub(' ', '_')}_strategy"
  end

  # generate the @picture_list information based on
  #   portrait and portraits to_parts strategy
  def default_strategy
    #puts "begin default_strategy for #{limit} faces"
    list = portrait_to_parts_strategy(limit)
    if list.present?
      #puts "matched single portrait"
      list.first[:used] = true
      add_faces(list.first)
    else
      #puts "matched multiple portrait"
      face_list = portraits_to_parts_strategy(limit)
      raise "Have no face info" if face_list.size != limit
      face_list.each { |face| add_face(face.portrait, face) }
    end
  end

  def to_picture_list(portrait, face=nil)
    {portrait: portrait, face: face, photo_part: next_photo_part}
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

  # Look for a single portrait that contains the exact amount of faces for the number_of_parts
  #   1) portrait has not previously been used in a previous offer
  #   2) portrait has not been used in this offer
  #   3) portrait has been used in a previous offer
  #   4) portrait has been used in this offer
  def portrait_to_parts_strategy(number_of_parts)
    list = faces_not_used_previously(number_of_parts)
    list = faces_not_used(number_of_parts) if list.empty?
    list = faces_used_previously(number_of_parts) if list.empty?
    list = faces_used(number_of_parts) if list.empty?
    list
  end

  # Gather as many portrait faces as number_of_parts
  def portraits_to_parts_strategy(number_of_parts)

    face_list = grab_faces_not_used_previously(number_of_parts)
    face_list.compact!
    faces_left = number_of_parts - face_list.size

    if faces_left > 0
      l = grab_faces_not_used(faces_left)
      face_list.concat(l)
      face_list.compact!
      faces_left = number_of_parts - face_list.size
    end
    if faces_left > 0
      l = grab_faces_used_previously(faces_left)
      face_list.concat(l)
      face_list.compact!
      faces_left = number_of_parts - face_list.size
    end
    if faces_left > 0
      l = grab_faces_used(faces_left)
      face_list.concat(l)
      face_list.flatten.compact!
      faces_left = number_of_parts - face_list.size
    end
    if faces_left > 0
      # guess we need to load portraits without faces???
      faces = grab_faces
      (faces_left).times do |i|
        index = i % faces.size
        face_list << faces[index]
      end if faces.present?
      faces_left = number_of_parts - face_list.size
    end
    if faces_left > 0
      raise "have a face issue need:#{number_of_parts} left:#{faces_left}"
    end
    face_list
  end

  # Face information that matches the number of parts
  def faces_not_used_previously(number_of_parts)
    match_faces_previous(number_of_parts, previously_used=false)
  end

  def faces_used_previously(number_of_parts)
    match_faces_previous(number_of_parts, previously_used=true)
  end

  def faces_not_used(number_of_parts)
    match_faces_current(number_of_parts, used=false)
  end

  def faces_used(number_of_parts)
    match_faces_current(number_of_parts, used=true)
  end

  # faces that have or have not been used in this offer
  def match_faces_current(number_of_parts, used=false)
    @by_faces[number_of_parts].present? ? @by_faces[number_of_parts].select { |entry| (entry[:used] == used) } : []
  end

  # faces that have or have not been used in this previous offers
  def match_faces_previous(number_of_parts, previously_used=false)
    @by_faces[number_of_parts].present? ? @by_faces[number_of_parts].select { |entry| (entry[:previously_used] == previously_used) } : []
  end


  # return a list of entries where the number of faces in portrait match number_of_parts
  def faces_to_parts_strategy(number_of_parts, used=false)
    @list.select { |entry| (entry[:used] == used) and (entry[:portrait].faces.size == number_of_parts) }
  end

  # Face information that doesn't care if they match the number of parts
  def grab_faces_not_used(faces_needed)
    faces = grab_faces_current(used=false, faces_needed)
    if faces.present?
      #  mark as being used
      portrait_ids = faces.collect { |r| r.portrait.id }.compact
      @list.each do |entry|
        entry[:used] = true if portrait_ids.include?(entry[:portrait].id)
      end
    end
    faces
  end

  def grab_faces_used(faces_needed)
    grab_faces_current(used=true, faces_needed)
  end

  def grab_faces_not_used_previously(faces_needed)
    faces = grab_faces_previous(previously_used=false, faces_needed)

    if faces.present?
      #  mark as being used
      portrait_ids = faces.collect { |r| r.portrait.id }.compact
      @list.each do |entry|
        entry[:used_previous] = true if portrait_ids.include?(entry[:portrait].id)
      end
    end
    faces
  end

  def grab_faces_used_previously(faces_needed)
    grab_faces_previous(previously_used=true, faces_needed)
  end

  def grab_faces_previous(previously_used, faces_needed)
    list  = @list.select { |entry| (entry[:used_previous] == previously_used) and (entry[:portrait].faces.size.to_i > 0) }
    faces = list.collect { |entry| entry[:portrait].faces }.flatten
    faces[0...faces_needed]
  end

  def grab_faces_current(used, faces_needed)
    list    = @list.select { |entry| (entry[:used] == used) and (entry[:portrait].faces.size.to_i > 0) }
    faces   = list.collect {|entry| entry[:portrait].faces}.flatten
    faces[0...faces_needed]
  end

# all faces regardless of used or not
  def grab_faces
    list = @list.select { |entry| (entry[:portrait].faces.size.to_i > 0) }
    list.collect { |entry| entry[:portrait].faces }.flatten.compact
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
    end if Rails.env.development?
  end

end