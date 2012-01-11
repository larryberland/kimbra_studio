class Studio::Shoot < ActiveRecord::Base
  belongs_to :studio
  belongs_to :client
  belongs_to :category

  has_many :pictures, :dependent => :destroy

  # allow the forms to send in a text name
  def category_name=(category_name)
    self.category = Category.find_or_initialize_by_name(category_name)
  end

  def category_name
    category.name if category
  end

end
