class Admin::Merchandise::PartsController < InheritedResources::Base

  before_filter :navbar_active

  belongs_to :piece,
             :parent_class => Admin::Merchandise::Piece
             #:finder => :my_piece
  #defaults :resource_class => Admin::Merchandise::Part,
  #         :collection_name => 'admin_merchandise_parts',
  #         :instance_name => 'admin_merchandise_part'

  private

  def navbar_active
    @navbar_active = :merchandise
  end

end
