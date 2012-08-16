class Prospect < ActiveRecord::Base

  attr_accessible :email

  validates :email,
            presence: true,
            format:   {with: CustomValidators::Emails.email_validator},
            length:   {maximum: 50}

end