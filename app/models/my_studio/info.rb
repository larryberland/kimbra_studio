class MyStudio::Info < ActiveRecord::Base
  belongs_to :studio

  validates :email, :presence => true,
            :format           => {:with => CustomValidators::Emails.email_validator},
            :length           => {:maximum => 255}

end
