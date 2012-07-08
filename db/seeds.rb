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
admin = User.find_by_email ('admin@kimbraclickplus.com')
admin.destroy if admin
admin = User.create(email: 'admin@kimbraclickplus.com',
                    password: 'kimbrarul3s',
                    role: Role.find_by_name(Role::SUPER_ADMIN))
if admin.errors.present?
  puts "create admin errors=>#{admin.errors.full_messages.join('\n')}"
end

Category::NAMES.each do |category_type|
  Category.find_or_create_by_name(category_type)
end

# seed studio for testing
require Rails.root.join('db', 'my_studio_seeds.rb').to_s
MyStudioSeeds.seeds(seed_path)

# Load up tax rates table for Colorado.
require 'csv'
ZipCodeTax.delete_all
tax_file = Rails.root.join('TAXRATES_ZIP5_CO201204.csv')
CSV.foreach(tax_file, headers: true) do |row|
  ZipCodeTax.create(
      state: row['state'].to_s.strip,
      zip_code: row['zip_code'].to_s.strip,
      tax_region_name: row['tax_region_name'].to_s.strip,
      tax_region_code: row['tax_region_code'].to_s.strip,
      combined_rate: row['combined_rate'],
      state_rate: row['state_rate'],
      county_rate: row['county_rate'],
      city_rate: row['city_rate'],
      special_rate: row['special_rate']
  )
end
if ZipCodeTax.count > 600
  puts "created #{ZipCodeTax.count} tax items for Colorado."
else
  puts 'ZIPCODETAX LOADER FAILED!'
end

# Add real shipping options.
[['Regular Ground Shipping USA', 995, 'Travel time is 3 to 5 business days.'],
 ['2nd Day Air Shipping USA', 2495, 'Travel time is 2 business days.'],
 ['Next Day Air Shipping USA', 3295, 'Travel time is overnight.'],
 ['Alaska Shipping', 2500, 'Delivery to Alaska.'],
 ['Canada Shipping', 2695, 'Delivery to Canada.'],
 ['Hawaii Shipping', 2500, 'Delivery to Hawaii.'],
 ['Mexico Shipping', 3295, 'Delivery to Mexico.'],
 ['Outside USA, Mexico and Canada', 4800, 'Delivery to most countries outside North America. ' +
     'Some countries are excluded. We\'ll contact you if there\'s a problem.']].each_with_index do |item, index|
  ShippingOption.create :name => item.first, :cost_cents => item.second, :description =>item.last, :sort_order => index
end
if ShippingOption.count > 6
  puts "created #{ShippingOption.count} shipping options."
else
  puts 'ShippingOption LOADER FAILED!'
end