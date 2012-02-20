class Minisite::ShowroomsController < InheritedResources::Base

  layout 'showroom'

  #minisite_showroom_show GET    /minisite/showrooms/:showroom_id/customer/:id/studio/:id(.:format)              {:action=>"show", :controller=>"minisite/showrooms"}
  #    minisite_showrooms GET    /minisite/showrooms(.:format)                                                   {:action=>"index", :controller=>"minisite/showrooms"}
  #                       POST   /minisite/showrooms(.:format)                                                   {:action=>"create", :controller=>"minisite/showrooms"}
  # new_minisite_showroom GET    /minisite/showrooms/new(.:format)                                               {:action=>"new", :controller=>"minisite/showrooms"}
  #edit_minisite_showroom GET    /minisite/showrooms/:id/edit(.:format)                                          {:action=>"edit", :controller=>"minisite/showrooms"}
  #     minisite_showroom GET    /minisite/showrooms/:id(.:format)                                               {:action=>"show", :controller=>"minisite/showrooms"}
  #                       PUT    /minisite/showrooms/:id(.:format)                                               {:action=>"update", :controller=>"minisite/showrooms"}
  #                       DELETE /minisite/showrooms/:id(.:format)                                               {:action=>"destroy", :controller=>"minisite/showrooms"}

  #respond_to do |format|
  #  format.css do
  #    render :text => Sass::Engine.new(render_to_string, syntax: :scss, cache: false).render
  #  end
  #end


end