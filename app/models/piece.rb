class Piece < ActiveRecord::Base
  # This returns the first featured piece in the database,
  # if there isn't a featured piece the first product will be returned
  #
  # @param [none]
  # @return [ Piece ]
  def self.featured
    piece = where({ :pieces => {:featured => true} } ).includes(:images).first
    piece ? piece : includes(:images).where(['pieces.deleted_at IS NULL']).first
  end

  def self.active
    where({ :pieces => {:active => true} } )
  end

end
