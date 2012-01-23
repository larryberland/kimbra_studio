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

require Rails.root.join('db', 'merchandise_seeds.rb').to_s
MerchandiseSeeds.seeds(seed_path)

roles = Role::ROLES
roles.each do |role|
  Role.find_or_create_by_name(role)
end

Category::NAMES.each do |category_type|
  Category.find_or_create_by_name(category_type)
end

# seed studio for testing
require Rails.root.join('db', 'my_studio_seeds.rb').to_s
MyStudioSeeds.seeds(seed_path)



