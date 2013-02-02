class Category < ActiveRecord::Base

  BABIES     = 'Babies'
  CHILDREN   = 'Children'
  FAMILY     = 'Family'
  MATERNITY  = 'Maternity'
  ENGAGEMENT = 'Engagement'
  WEDDING    = 'Wedding'
  GRADUATION = 'Graduation'
  MILITARY   = 'Military'
  GLAMOR     = 'Glamor and Makeover'
  PETS       = 'Pets'
  OTHER      = 'Other'

  NAMES = [BABIES,
           CHILDREN,
           FAMILY,
           MATERNITY,
           ENGAGEMENT,
           WEDDING,
           GRADUATION,
           MILITARY,
           GLAMOR,
           PETS,
           OTHER]

end