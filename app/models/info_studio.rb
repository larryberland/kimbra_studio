# t.boolean  "active"
# t.string   "email_info"
# t.string   "email"
# t.string   "tax_id"
# t.string   "website"
# t.boolean  "pictage_member"
# t.boolean  "mac_user"
# t.boolean  "windows_user"
# t.boolean  "ping_email"
# t.datetime "created_at"
# t.datetime "updated_at"
# t.integer  "studio_id"

class InfoStudio < ActiveRecord::Base
  belongs_to :studio

  validates :email, :presence => true,
            :format           => {:with => CustomValidators::Emails.email_validator},
            :length           => {:maximum => 255}

end
