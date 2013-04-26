class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :log_session
  before_filter :authenticate_user!
  before_filter :setup_session
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

  # entry point to properly coordinate session info
          #   for a client when viewing our site
  def setup_session

    session[:email_cart] ||= {}
    Rails.logger.info "SETUP_SESSION:email_cart:#{session[:email_cart].inspect}"

    # retrieve the email offer we are working with
    load_email

    # retrieve the studio we are working with
    load_my_studio

    # finally uncover the client we are working with
    load_client

  end

  private #=========================================================================

  def minisite_info_inherited_resources
    # override if you need to handle this
  end

  # Shopping controllers that are expecting a params[:cart_id]
  # Minisite controllers that are expecting a params[:email_id]
  # some controllers that are expecting a params[:id]
  def load_email_or_cart
    # no-op for everyone except minisite and shopping controllers
    # implement this method in your controller to handle any special
    # processing to pull out model info based on inherited resources
    #   and/or tracking numbers
  end

  # wrapper for the many ways we figure out the email we are
  #   working with in our views and controllers
  def load_email

    # minisite controllers that have inherited_resources
    #   get first crack at determining current session email
    # currently items and item_sides
    minisite_info_inherited_resources

    # Shopping controllers that are expecting a params[:cart_id]
    # Minisite controllers that are expecting a params[:email_id]
    # some controllers that are expecting a params[:id]
    load_email_or_cart
  end

  def load_my_studio
    if (is_studio?)
      @my_studio = current_user.studio if current_user
    elsif @admin_customer_email
      @my_studio = @admin_customer_email.my_studio_session.studio
    end
    # namespace and non_namespace to make everyone happy
    @studio = @my_studio
  end

  def load_client
    if @admin_customer_email
      @client = @admin_customer_email.my_studio_session.client
    end
  end

  def push_session_email_cart

    # hash of cart_id key with a value of the email it belongs to
    session[:email_cart][session[:email_id]] = {cart_id:   session[:cart_id],
                                                friend_id: session[:friend_id]}

  end

  # using the email passed in verify our current
  #   session[:cart_id] ad session[:email_id] are in sync
  def sync_session_email(email)
    raise "Expecting @cart to always be nil here" if @cart.present?
    raise "Do not call sync_session_email() without a valid id email:#{email}" if email.new_record?

    Rails.logger.info "sync_session_email(email_id:#{email.id} session[:email_id]:#{session[:email_id]} session[:cart_id]:#{session[:cart_id]} "

    if session[:email_id]

      if session[:email_id] != email.id

        raise "want to know if we have a non-existing email" if email.new_record?

        # push the current session info into our emails array
        push_session_email_cart

        # return the previous session data referenced
        # by this email.id
        session[:email_cart][email.id] ||= {}

        # any email specific session info
        session[:cart_id]              = session[:email_cart][email.id][:cart_id]
        session[:friend_id]            = session[:email_cart][email.id][:friend_id]

      end

      # verify this cart may exist or not
      @cart = Shopping::Cart.find_by_id(session[:cart_id])
      @cart = Shopping::Cart.create(email: email) if @cart.nil?

      @admin_customer_friend = Admin::Customer::Friend.find_by_id(session[:friend_id])
      @admin_customer_friend = email.create_friend(@cart) if @admin_customer_friend.nil?

    else
      # first time session for this email
      @cart                  = Shopping::Cart.create(email: email)
      @admin_customer_friend = email.create_friend(@cart)
    end

    # this is our current session info going forward
    session[:email_id]  = email.id
    session[:cart_id]   = @cart.id
    session[:friend_id] = @admin_customer_friend.id

    # persist our email specific data into our email_cart
    push_session_email_cart

    Rails.logger.info("session [:email_id]:#{session[:email_id]} [:cart_id]:#{session[:cart_id]} [:friend_id]:#{session[:friend_id]}")

  end

  def setup_story
    Rails.logger.info("some filter did not set our current @client") if @client.nil?
    Rails.logger.info("some filter did not set our current @studio") if @studio.nil?
    @story, @storyline = Story.setup(request, controller_name, action_name, @client, @studio, is_client?)
  end

  def current_user_facebook
    @current_user_facebook ||= FacebookUser.find(session[:facebook_user_id]) if session[:facebook_user_id]
  end

  helper_method :current_user_facebook

  def authenticate_admin!
    current_user && current_user.admin?
  end

  def do_not_cache
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma']        = 'no-cache'
    response.headers['Expires']       = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  def log_session
    if Rails.env.development?
      puts "RAILS SESSION: #{session.inspect}"
      logger.info "RAILS SESSION: #{session.inspect}"
    end
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
      session[:cart_id]    = nil
      session[:email_id]   = nil
      session[:email_cart] = {}
    end
  end

  def track_a_studio_email
    if params[:studio_email] && params[:studio_id]
      # Check that the email name is recognized.
      if Notifier.instance_methods(false).include?(params[:studio_email].to_sym)
        StudioEmail.update_click_through(params[:studio_id], params[:studio_email])
      end
    end
  end

end