class MyStudio::FacesController < InheritedResources::Base

  before_filter :load_my_studio

  belongs_to :portrait,
             :parent_class => MyStudio::Portrait

  private #=================================================================

  def load_my_studio
    @my_studio = current_user.studio if current_user
  end

end