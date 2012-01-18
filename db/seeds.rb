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
pieces_list.each do |piece|
  parts = piece.delete(:parts)

  path = image_path.join(piece['category'].underscore.gsub(' ', '_'))
  p    = Admin::Merchandise::Piece.find_or_create_by_category_and_name(piece['category'], piece['name'])

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
    fname = piece['name'].underscore.gsub(' ','_')
    ['jpeg','png'].each do |ext|
      if File.exists?(path.join("#{fname}.#{ext}").to_s)
        p.image.store!(File.open(path.join("#{fname}.#{ext}").to_s))
      end
    end
    if p.image_url.blank?
      puts "missing Piece #{fname}.[png|jpeg]  in #{piece['category']}/#{piece['name']}"
    end
  end

  # seed the parts for this Jewelry Piece
  p.parts.destroy_all if p.parts.present?
  path = path.join(piece['name'].underscore.gsub(' ', '_'))
  parts.each do |part|
    part_image_fname = path.join(part[:image])
    img              = Magick::Image.read(part_image_fname.to_s)[0].strip!
    my_part = Admin::Merchandise::Part.create(:width => img.columns, :height => img.rows)
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


