class Category < ActiveRecord::Base
  WEDDING    = 'wedding'
  ENGAGEMENT = 'engagement'
  PORTRAIT   = 'portrait'
  PREGNANCY  = 'pregnancy'
  INFANTS    = 'infants'
  CHILDREN   = 'children'
  GRADUATION = 'graduation'

  NAMES      = [WEDDING,
                ENGAGEMENT,
                PORTRAIT,
                PREGNANCY,
                INFANTS,
                CHILDREN,
                GRADUATION]
end
