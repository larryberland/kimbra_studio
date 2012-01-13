class Category < ActiveRecord::Base

  BABIES     = 'Babies'
  CHILDREN   = 'Children'
  FAMILY     = 'Family'
  MATERNITY  = 'Maternity'
  HOLIDAY    = 'Holiday Portraits'
  COUPLES    = 'Couples'
  GRADUATION = 'Graduation'
  MILITARY   = 'Military'
  SPORTS     = 'Sports & Activities'
  RELIGIOUS  = 'Religious & Special Occasions'
  BUSINESS   = 'Business'
  PETS       = 'Pets'
  STORY      = 'Story Booth Portraits'

  NAMES = [BABIES,
           CHILDREN,
           FAMILY,
           MATERNITY,
           HOLIDAY,
           COUPLES,
           GRADUATION,
           MILITARY,
           SPORTS,
           RELIGIOUS,
           BUSINESS,
           PETS,
           STORY]

  has_many :shoots

end
