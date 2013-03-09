class State < ActiveRecord::Base

  belongs_to :country
  has_many :users
  has_many :studios

  validates :name, presence: true, length: {maximum: 150}
  validates :abbreviation, presence: true, length: {maximum: 12}
  validates :country_id, presence: true

  before_save :monitor

  # filter all the states for a form for a given country_id
  #
  # @param [Integer] country_id
  # @return [ Arel ]
  scope :by_country, lambda { |country_id| where('country_id = ?', country_id) }

  def stripe
    abbreviation.to_s
  end

  def country_stripe
    country.try(:stripe)
  end

  # the abbreviation and name of the state separated by '-' and optionally appended by characters
  #
  # @param [none]
  # @return [ String ]
  def abbreviation_name(append_name = "")
    ([abbreviation, name].join(" - ") + " #{append_name}").strip
  end

  # the abbreviation and name of the state separated by '-'
  #
  # @param [none]
  # @return [ String ]
  def abbrev_and_name
    abbreviation_name
  end

  def form_selector_option
    [abbrev_and_name, id]
  end

  # method to get all the states for a form
  # [['NY New York', 32], ['CA California', 3] ... ]
  #
  # @param [none]
  # @return [ Array[Array] ]
  def self.form_selector
    find(:all, :order => 'country_id DESC, abbreviation ASC').collect(&:form_selector_option)
  end

  private

  def monitor
    puts "state saving:#{self.inspect}"
    true
  end

end
