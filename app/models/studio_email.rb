class StudioEmail < ActiveRecord::Base

  belongs_to :studio

  scope :sent_to, lambda {|studio| where(studio_id: studio)}

  scope :sent_email, lambda {|email| where(email_name: email)}

  def self.update_click_through(studio_id, email_name)
    if studio_email = self.where(studio_id: studio_id).where(email_name: email_name).try(:first)
      studio_email.update_attribute(:clicked_through_at, Time.now) unless studio_email.clicked_through_at
    end
  end

end