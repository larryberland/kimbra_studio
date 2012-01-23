class MyStudio::FacesController < InheritedResources::Base
  belongs_to :portrait,
             :parent_class => MyStudio::Portrait
end
