class PieceStrategy

  def initialize
    @by_categories = Admin::Merchandise::Piece.all.group_by{|r|r.category}
    @piece_list = []
  end

  def pick_pieces
    # pick 1 from each category
    @by_categories.each do |category, pick_list|
      random_indices = (0...pick_list.size).to_a.shuffle
      index = random_indices.pop
      @piece_list << pick_list[index]
    end
    @piece_list
  end

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
end