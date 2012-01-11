class Category < ActiveRecord::Base
  WEDDING       = 'wedding'
  ENGAGEMENT    = 'engagement'
  PORTRAIT      = 'portrait'
  PREGNANCY     = 'pregnancy'
  INFANTS       = 'infants'
  CHILDREN      = 'children'
  GRADUATION    = 'graduation'
  SPECIAL_EVENT = 'special event'

  NAMES = [WEDDING,
           ENGAGEMENT,
           PORTRAIT,
           PREGNANCY,
           INFANTS,
           CHILDREN,
           GRADUATION,
           SPECIAL_EVENT]

  has_many :shoots

end
