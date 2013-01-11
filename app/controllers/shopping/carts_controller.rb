module Shopping
  class CartsController < BaseController

    skip_before_filter :handle_roles, only: [:edit_delivery_tracking, :update_delivery_tracking, :find_by_tracking]
    skip_before_filter :setup_story, only: [:edit_delivery_tracking, :update_delivery_tracking, :find_by_tracking]

    before_filter :override_setup_session, only: [:edit_delivery_tracking, :update_delivery_tracking]

    def show
      @storyline.describe "Viewing cart (#{@cart.quantity} pieces present)."
    end

    def find_by_tracking
      @shopping_cart = Shopping::Cart.new
      render layout: false
    end

    def edit_delivery_tracking
      if params[:shopping_cart] && params[:shopping_cart][:tracking].present?
        if @shopping_cart
          @shipping = @shopping_cart.shipping
          @shipping ||= Shopping::Shipping.new
          # allow to render.
        else
          flash[:notice] = "Could not find any order with number like #{params[:shopping_cart][:tracking]}."
          return redirect_to '/delivery'
        end
      else
        flash[:notice] = 'Need an order number. Like k2s4f921ms '
        return redirect_to '/delivery'
      end
    end

    def update_delivery_tracking
      if @shopping_cart = Shopping::Cart.find_by_tracking(params[:id])
        if tracking = params[:shopping_shipping] && params[:shopping_shipping][:tracking]
          @shipping = @shopping_cart.shipping
          @shipping.tracking = tracking
          if @shipping.save
            flash[:notice] = "Delivery tracking number #{@shipping.tracking} saved for #{@shopping_cart.address.last_name}. Sent them an email with shipping update."
            @studio = @shopping_cart.email.my_studio_session.studio
            ClientMailer.delay.send_shipping_update(@shopping_cart.id, @studio.id)
            return redirect_to '/delivery'
          else # errors on save
            return render :edit_delivery_tracking
          end
        else # no tracking
          flash[:error] = 'Must enter a tracking number.'
          return render :edit_delivery_tracking
        end
      else # no cart
        flash[:error] = "Could not find order with number #{params[:id]}"
        return redirect_to '/delivery'
      end
    end

    private

    def override_setup_session
      if params[:shopping_cart] && params[:shopping_cart][:tracking].present?
        if @shopping_cart = Shopping::Cart.find_by_tracking(params[:shopping_cart][:tracking])
          @admin_customer_email = @shopping_cart.email
          @studio = @admin_customer_email.my_studio_session.studio
          @client = @admin_customer_email.my_studio_session.client
        end
      end
    end

  end
end