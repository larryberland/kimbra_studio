class PieceStrategy

  def initialize(email)
    @outgoing_email  = email
    @by_categories   = Admin::Merchandise::Piece.to_strategy
    @photo_bracelets = @by_categories.delete('Photo Bracelets')
    @piece_list      = []
  end

  def pick_pieces
    # remove any previous offers we have already sent
    @outgoing_email.previous_offers.each do |offer|
      raise "why do we have an offer without a piece?" if offer.piece.nil?
      @by_categories[offer.piece.category].delete_if { |r| r.id == offer.piece.id } if @by_categories[offer.piece.category].present?
    end
                        # pick 1 from each of the remaining categories
    @by_categories.each do |category, pick_list|
      random_indices = (0...pick_list.size).to_a.shuffle
      index          = random_indices.pop
      @piece_list << pick_list[index]
    end
    pick_photo_bracelet # always have one bracelet
    @piece_list
  end

  # used mainly for testing a specific category
  def pick_category(category=nil)
    category ||= @by_categories.keys.first
    @by_categories.each do |c, pick_list|
      if c == category
        @piece_list = pick_list
        break
      end
    end
    @piece_list
  end

  private

  # Photo bracelets will be picked based on the current email for this client
  def pick_photo_bracelet
    index = @outgoing_email.previous_emails.count % @photo_bracelets.count
    @piece_list << @photo_bracelets[index]
  end
end