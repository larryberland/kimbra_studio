class MyStudio::Client < ActiveRecord::Base

  has_many :sessions, class_name: 'MyStudio::Session', dependent: :destroy

  attr_accessible :name, :email, :phone_number, :active

  validates :name, presence: true
  validates :email,
            presence: true,
            format:   {with: CustomValidators::Emails.email_validator},
            length:   {maximum: 50}

  before_validation :filter_data

  def to_error_messages
    kustom = {}
    messages =[]
    if (errors.present?)
      errors.messages.each do |k,descriptions|
        descriptions.each do |description|
          if (description == "can't be blank")
            kustom[:multiple_fields] = "Both Name and Email are required."
          else
            kustom[k] = description
          end
        end
      end
      messages = kustom.collect{|k,msg| k == :multiple_fields ? "#{msg}" : "#{k.to_s.titleize} #{msg}"}
      messages = errors.full_messages
    end
    messages

  end

  def phone_number=(num)
    super num.to_s.gsub(/\D/,'')[0,10]
  end

  private

  def filter_data
    self.email.downcase! if email.present?
    true
  end
end