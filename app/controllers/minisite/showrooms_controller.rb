class Minisite::ShowroomsController < InheritedResources::Base

  before_filter :set_by_tracking

  layout 'showroom'

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

  def collection
    @showroom = Minisite::Showroom.find_by_tracking(params[:id])
    @showrooms = Minisite::Showroom.where(:email_id => @showroom.email_id)
  end

  private #=======================================================

  # We use tracking number instead of :id in routes. Use tracking to establish showroom.
  # Use showroom to establish client. Use session to store both.
  # Client and showroom should always be in the session after the first visit.
  # We don't support changing between multiple clients or showrooms in one session.
  def set_by_tracking
    @showroom = Minisite::Showroom.find_by_tracking(params[:id]) if params[:id]
    @showroom = Minisite::Showroom.find(session[:showroom_id]) if @showroom.nil? && session[:showroom_id]
    session[:showroom_id] = @showroom.id
    @client = @showroom.client if @showroom
    session[:client_id] = @client.id if @client
    @client = MyStudio::Client.find(session[:client_id]) if @client.nil? && session[:client_id].present?
  end

end