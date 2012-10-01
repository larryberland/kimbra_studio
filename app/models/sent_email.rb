class SentEmail < ActiveRecord::Base

  scope :in_last_month, lambda { where("created_at >= ?", 1.month.ago) }

  def email=(arg)
    self[:email] = arg.downcase rescue nil
  end

  def self.are_we_spamming(address)
    SentEmail.in_last_month.where(email: address.downcase).count > 0
  end

  def self.sent_studio_eap_email?(email)
    SentEmail.where(email: email).collect(&:subject).select{|s| s.match /EAP/ }.present?
  end

end