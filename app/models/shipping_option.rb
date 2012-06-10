class ShippingOption < ActiveRecord::Base

  validates :name, :presence => true
  validates :cost_cents, :presence => true
  validates :description, :presence => true

  def self.form_selections
    find(:all, :order => 'sort_order ASC').collect { |item| ["#{item.name} -- #{ActionController::Base.helpers.number_to_currency item.cost_cents / 100.0}", item.name] }
  end

end