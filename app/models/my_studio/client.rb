class MyStudio::Client < ActiveRecord::Base

  has_many :sessions, class_name: 'MyStudio::Session', dependent: :destroy

  attr_accessible :name, :email, :phone_number, :active

  validates :name, presence: true
  validates :email,
            presence: true,
            format:   {with: CustomValidators::Emails.email_validator},
            length:   {maximum: 50}

  def phone_number=(num)
    super num.to_s.gsub(/\D/,'')[0,10]
  end

end