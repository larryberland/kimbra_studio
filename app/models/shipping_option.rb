class ShippingOption < ActiveRecord::Base

  OPTIONS = [['Regular Ground Shipping USA', 995, 'Travel time is 3 to 5 business days.'],
             ['2nd Day Air Shipping USA', 2495, 'Travel time is 2 business days.'],
             ['Next Day Air Shipping USA', 3295, 'Travel time is overnight.'],
             ['Alaska Shipping', 2500, 'Delivery to Alaska.'],
             ['Canada Shipping', 2695, 'Delivery to Canada.'],
             ['Hawaii Shipping', 2500, 'Delivery to Hawaii.'],
             ['Mexico Shipping', 3295, 'Delivery to Mexico.'],
             ['Outside USA, Mexico and Canada', 4800, 'Delivery to most countries outside North America. Some countries are excluded. We\'ll contact you if there\'s a problem.']]

  validates :name, presence: true
  validates :cost_cents, presence: true
  validates :description, presence: true

  def total
    cost_cents / 100.0
  end

  def self.form_selections
    order('sort_order ASC').collect { |item| ["#{item.name} -- #{ActionController::Base.helpers.number_to_currency item.total}", item.name] }
  end

end