class OfferEmail

  def initialize
    raise "did you forget to call Studio::setup?" if @studio.nil?
    @email = create(:offer_email, :with_cart)
    self
  end

end