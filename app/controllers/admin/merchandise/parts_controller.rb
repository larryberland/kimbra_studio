class Admin::Merchandise::PartsController < InheritedResources::Base
  belongs_to :piece,
             :parent_class => Admin::Merchandise::Piece
             #:finder => :my_piece
  #defaults :resource_class => Admin::Merchandise::Part,
  #         :collection_name => 'admin_merchandise_parts',
  #         :instance_name => 'admin_merchandise_part'
end
