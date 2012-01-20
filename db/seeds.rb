# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

seed_path = Rails.root.join('db', 'seed')

file_to_load   = seed_path.join('countries.yml').to_s
countries_list = YAML::load(File.open(file_to_load))

countries_list.each_pair do |key, country|
  s = Country.find_by_abbreviation(country['abbreviation'])
  Country.create(country) unless s
end

file_to_load = seed_path.join('states.yml').to_s
states_list  = YAML::load(File.open(file_to_load))

states_list.each_pair do |key, state|
  s = State.find_by_abbreviation_and_country_id(state['attributes']['abbreviation'], state['attributes']['country_id'])
  State.create(state['attributes']) unless s
end

image_path   = Rails.root.join('public', 'kimbra')
file_to_load = seed_path.join('pieces.yml').to_s
pieces_list  = YAML::load(File.open(file_to_load))[:pieces]
image_stub = Rails.root.join('app','assets','images','home.png')
pieces_list.each do |piece|
  parts = piece.delete(:parts)

  path = image_path.join(piece['category'].underscore.gsub(' ', '_'))
  path.mkpath unless path.directory?

  p = Admin::Merchandise::Piece.find_or_create_by_category_and_name(piece['category'], piece['name'])

  piece_image_fname = piece.delete('image')
  if piece_image_fname
    fname = path.join(piece_image_fname)
    if File.exist?(fname.to_s)
      puts "STORING #{piece_image_fname}"
      p.image.store!(File.open(fname.to_s))
    else
      puts "missing Piece image fname=>#{piece_image_fname} in #{piece['category']}/#{piece['name']} image=>#{fname}"
    end
  else
    # look for an image
    fname = piece['name'].underscore.gsub(' ', '_')
    ['jpeg', 'png'].each do |ext|
      if File.exists?(path.join("#{fname}.#{ext}").to_s)
        p.image.store!(File.open(path.join("#{fname}.#{ext}").to_s))
      end
    end
    if p.image_url.blank?
      puts "missing Piece #{fname}.[png|jpeg]  in #{piece['category']}/#{piece['name']}"
      p.image.store!(File.open(image_stub.to_s)) # stub them for now
    end
  end

  # seed the parts for this Jewelry Piece
  p.parts.destroy_all if p.parts.present?
  path = path.join(piece['name'].underscore.gsub(' ', '_'))
  path.mkpath unless path.directory?
  parts.each do |part|
    part_image_fname = path.join(part.delete(:image_part))
    my_part          = Admin::Merchandise::Part.create(part)
    my_part.image_part.store!(File.open(part_image_fname.to_s))
    p.parts << my_part
  end if parts.present?

  p.update_attributes(piece)
end

roles = Role::ROLES
roles.each do |role|
  Role.find_or_create_by_name(role)
end

Category::NAMES.each do |category_type|
  Category.find_or_create_by_name(category_type)
end

# seed studio for testing
image_path   = Rails.root.join('public', 'studios')
file_to_load = seed_path.join('studios.yml').to_s
studios      = YAML::load(File.open(file_to_load))[:studios]
studios.each do |my_studio_attrs|

  if Studio.find_by_name(my_studio_attrs['name'])
    Studio.find_by_name(my_studio_attrs['name']).destroy
  end
  unless Studio.find_by_name(my_studio_attrs['name'])

    path = image_path.join(my_studio_attrs['name'].underscore.gsub(' ', '_'))
    path.mkpath unless path.directory?

    # create owner
    attrs = my_studio_attrs.delete('owner')
    owner = User.find_or_create_by_email(attrs['email'])
    owner.update_attributes(attrs.merge(:password => 'password'))

    # create Sessions
    index = 0
    sessions               = my_studio_attrs.delete('sessions').collect do |session_attrs|
      index += 1
      client      = MyStudio::Client.create(session_attrs.delete('client'))

      # load portraits
      client_path = path.join(client.name.underscore.gsub(' ', '_'))
      client_path.mkpath unless client_path.directory?
      portraits = client_path.children.collect do |p|
        if p.file?
          portrait = MyStudio::Portrait.create
          portrait.image.store!(File.open(p.to_s))
          portrait.save
          portrait
        end
      end

      s = MyStudio::Session.create(session_attrs.merge(:client => client, :session_at => index.days.ago))
      s.portraits = portraits if portraits.present?
      s.category = Category.find_by_name(session_attrs['name'])
      s.save
      s
    end

    # tie them all up into studio
    my_studio              = Studio.new(my_studio_attrs)
    my_studio.current_user = owner
    my_studio.owner        = owner
    my_studio.sessions     = sessions
    my_studio.save
    puts "my_studio #{my_studio.name} errors=>#{my_studio.errors.full_messages}"
  end
end


