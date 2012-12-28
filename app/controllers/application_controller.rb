class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :log_session
  before_filter :authenticate_user!
  before_filter :load_my_studio
  before_filter :navbar_active
  before_filter :track_a_studio_email

  layout 'application'

  # override devise url reference
  #  based on user's current roles
  def after_sign_in_path_for(resource)
    u  = stored_location_for(resource)
    u2 = signed_in_root_path(resource)
    # puts "u=>#{u}\nu2=>#{u2}"
    u || u2
  end

  def is_admin?
    defined?(current_user) and current_user and current_user.admin?
  end

  def is_studio?
    defined?(current_user) and current_user and current_user.studio?
  end

  def is_client?
    (is_admin? or is_studio?) ? false : true
  end

  def require_user
    redirect_to login_url and return if logged_out?
  end

  def logged_out?
    !current_user
  end

  def setup_story
    @story, @storyline = Story.setup(request, controller_name, action_name, @client, @studio, is_client?)
  end

  # @admin_customer_friend identifies the client's
          #   friend info for this session
  def in_my_collection?(offer)
    if (@admin_customer_friend)
      if (offer.suggestion?)
        false
      elsif (offer.friend and offer.friend.id != @admin_customer_friend.id)
        false
      else
        true
      end
    end
  end

  def setup_friend
    # current collection friend name
    if session[:admin_customer_friend_id]
      @admin_customer_friend = Admin::Customer::Friend.find_by_id(session[:admin_customer_friend_id]) rescue nil
    end
    if @admin_customer_friend.nil?
      if @admin_customer_email
        # client is coming in with a new session
        @admin_customer_friend             = @admin_customer_email.create_friend(@cart)
        session[:admin_customer_friend_id] = @admin_customer_friend.id
      else
        # did you forget to include a before_filter to load @admin_customer_email
        Rails.logger.info("WARN:setup_friend() missing email session:#{session.inspect}")
      end
    end
  end

  private #=========================================================================

  def minisite_info_inherited_resources
    set_by_tracking

    # convert inherited resources to our BaseController attrs
    @admin_customer_offer = @offer if @offer
    @admin_customer_email = @email if @email

    # minisite BaseController before_filter
    set_cart_and_client_and_studio

    # need @studio, @client
    setup_story

  end

  def current_user_facebook
    @current_user_facebook ||= FacebookUser.find(session[:facebook_user_id]) if session[:facebook_user_id]
  end

  helper_method :current_user_facebook

  def authenticate_admin!
    current_user && current_user.admin?
  end

  def do_not_cache
    response.headers['Cache-Control'] = 'no-chache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma']        = 'no-cache'
    response.headers['Expires']       = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  def load_my_studio
    if (is_admin?)
      @my_studio = Studio.find_by_id(session[:mock_collection_studio_id]) rescue nil
    else
      @my_studio = current_user.studio if current_user
    end
  end

  def log_session
    puts "RAILS SESSION: #{session.inspect}"
    logger.info "RAILS SESSION: #{session.inspect}"
  end

  # current navbar main menu
  #  :blog
  #  is_admin?
  #   :overview, :offer_emails, :studios, :users, :merchandise, :samples, :stories, :faqs
  #  is_studio?
  #   :photo_sessions, :infos_samples, :minisite, :dashboard
  def navbar_active
    # reset in controller for active navbar menu item
    @navbar_active = :overview
  end

  def reset_session_info
    if (is_admin?)
      # reset our minisite session info when an admin
      #   role leaves the minisite controllers
      if cart = Shopping::Cart.find_by_id(session[:cart_id])
        cart.destroy
      end
      session[:cart_id]                 = nil
      session[:admin_customer_email_id] = nil
      session[:client_id]               = nil
    end
  end

  # this should only be called by set_cart_and_client_and_studio
  def set_session_cart
    # Pull cart from current session; usually normal shopping activity.
    if @cart.nil? && session[:cart_id]
      # incoming url does not have a cart
      #   see if the session has a valid cart
      @cart = Shopping::Cart.find(session[:cart_id]) rescue nil
      if @cart
        # override the email record with the cart's info
        if Rails.env.development?
          if @cart.email.id != @admin_customer_email.id
            puts "session:#{session.inspect}"
            puts "email:#{@email.inspect}"
            puts "cart:#{@cart.inspect}"
            raise "mismatched email and cart"
          end
        end
        @admin_customer_email ||= @cart.email
      end
    end

    # Otherwise create new cart; we are starting a new shopping session.
    # Offer and email are already set.
    if @cart.nil?
      @cart             = Shopping::Cart.create(email: @admin_customer_email)
      session[:cart_id] = @cart.id
    end

  end

  # TODO This logic is tortured. Need to outline the different ways we get to this controller and set session vars accordingly.
  # Used by all controllers in the minisite Module
  # 1. From session begun by offer email.
  # 2. From session begun by confirmation email offer status link.
  # 3. From bookmarks to any interior page.
  # 4. where else?!? don't forget combinations of the above.
  def set_cart_and_client_and_studio

    # Pull cart from incoming link; usually confirmation email order status link.
    if params[:cart]
      # have a shopping cart to use
      @cart                 = Shopping::Cart.find_by_tracking(params[:cart])
      @admin_customer_email = @cart.email
      @admin_customer_offer = nil
    end

    if is_client?
      set_session_cart
      session[:admin_customer_email_id] = @admin_customer_email.id

      @client             = @admin_customer_email.my_studio_session.client
      session[:client_id] ||= @client.id

      @studio             = @admin_customer_email.my_studio_session.studio
      session[:studio_id] ||= @studio.id

      # current collection friend name
      setup_friend

    elsif is_studio?
      # studio and admin should have @cart and @client nil
      @studio = current_user.studio

      @admin_customer_friend = Admin::Customer::Friend.new(email: @admin_customer_email,
                                                           name:  @admin_customer_email.my_studio_session.client.name)

    else
      set_session_cart
      @studio             = @admin_customer_email.my_studio_session.studio
      # shopping session info
      session[:studio_id] = @studio.id

      @admin_customer_friend = Admin::Customer::Friend.new(email: @admin_customer_email,
                                                           name:  @admin_customer_email.my_studio_session.client.name)
    end
  end

  def track_a_studio_email
    if params[:studio_email] && params[:studio_id]
      # Check that the email name is recognized.
      puts "RIGHT HRERE"
      if Notifier.instance_methods(false).include?(params[:studio_email].to_sym)
        puts "HERE!"
        StudioEmail.update_click_through(params[:studio_id], params[:studio_email])
      end
    end
  end

end