module Shopping
  class CartsController < BaseController

    skip_before_filter :authenticate_user!,
                       only: [:find_by_tracking, :edit_delivery_tracking, :update_delivery_tracking]
    skip_before_filter :set_client_and_cart, :setup_story,
                       only: [:find_by_tracking]

    def find_by_tracking
      @cart = Shopping::Cart.new
      render layout: false
    end

    def edit_delivery_tracking
      if params[:shopping_cart] && params[:shopping_cart][:tracking].present?
        if @cart = Shopping::Cart.find_by_tracking(params[:shopping_cart][:tracking])
          @shipping = @cart.shipping
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
      if @cart = Shopping::Cart.find_by_tracking(params[:id])
        if tracking = params[:shopping_shipping] && params[:shopping_shipping][:tracking]
          @shipping = @cart.shipping
          @shipping.tracking = tracking
          if @shipping.save
            flash[:notice] = "Delivery tracking number #{@shipping.tracking} saved for #{@cart.address.last_name}."
            @studio = @cart.email.my_studio_session.client
            ClientMailer.send_shipping_update(@cart, @studio).deliver
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

  end
end