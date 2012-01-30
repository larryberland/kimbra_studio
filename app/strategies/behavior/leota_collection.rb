module LeotaCollection

  # 2 sided charms used for this bracelet
  # for each picture_list entry:
  #   picture_list[0] = [{:portrait, :face, :photo_part},
  #                      {:portrait, :face, :photo_part}]
  def leota_collection_strategy
    init

    #dump_list # debug

              # four parts needed
    raise "portrait_strategy config issue leota_collection max_parts expected 4 got #{@max_parts}" if @max_parts != 4

    # look for 8, 6, 4 or 2 faces that have not been used before
    [8, 6, 4, 2].each do |number_of_faces|
      #puts "UNused faces=>#{number_of_faces}"
      select_from_unused_matches(number_of_faces)
      break if limit?
    end

    unless limit?
      # look for 8, 6, 4 or 2 faces that have been used before
      [8, 6, 4, 2].each do |number_of_faces|
        #puts "used faces=>#{number_of_faces}"
        select_from_used_matches(number_of_faces)
        break if limit?
      end
    end

    unless limit?
      # select any that have at least 1 face and not used yet
      #puts "used any faces"
      select_from_face_list(match_any_face)
    end

    unless limit?
      # have at least 1 face and has been used before
      #puts "UNused any faces"
      select_from_face_list(match_any_face(used=true))
    end

    unless limit?
      # need to fill up the pictures regardless of used or not
      while !limit?
        @list.each do |entry|
          entry[:used] = true
          if entry[:portrait].faces
            entry[:portrait].faces.each do |face|
              add(entry[:portrait], face)
              break if limit?
            end
          else
            add(entry[:portrait], nil)
          end
          break if limit?
        end
      end
    end
    if @picture_list.size != 4
      puts "fix this"
    end
    raise "missing all parts expected 4 got #{@picture_list.size}" if @picture_list.size != 4
    @picture_list

  end

  private

  def init
    @max_pictures    = 8
    @number_pictures = -1
  end

  def limit_pictures
    @max_pictures
  end

  def limit_pictures?
    @number_pictures >= limit_pictures
  end

  # add the front and back side to a single photo_part
  #  and add this to the picture list as an array
  #  of portrait, face, and part information
  def add_to_picture_list
    photo_part               = next_photo_part
    @front_side[:photo_part] = photo_part
    @back_side[:photo_part]  = photo_part
    @picture_list << [@front_side.clone,
                      @back_side.clone]
    @front_side = nil
    @back_side  = nil
  end

  # add this portrait and face to either the front or back side
  def add(portrait, face)
    if @front_side
      if @back_side
        raise 'should never be adding if both are filled'
      else
        @back_side = {:portrait => portrait, :face => face}
      end
    else
      @front_side = {:portrait => portrait, :face => face}
    end
    @number_pictures += 1
    add_to_picture_list if @front_side.present? and @back_side.present?
  end

  # using the list fill up the part picture_list
  #  with two face pictures per part
  def select_from_face_list(list)
    list.each do |entry|
      break if limit?
      entry[:used] = true
      entry[:portrait].faces.each do |face|
        add(entry[:portrait], face)
        break if limit?
      end
    end if list.present?
  end

  def select_from_unused_matches(number_of_faces)
    select_from_face_list(match_faces_to_parts(number_of_faces))
  end

  def select_from_used_matches(number_of_faces)
    select_from_face_list(match_faces_to_parts(number_of_faces, used=true))
  end

end