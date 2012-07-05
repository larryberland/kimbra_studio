class MyStudio::PasswordResetsController < ApplicationController

  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
    @user = User.new
    #render
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    if @user
      # TODO add .delay to this call somehow for DJ.
      @user.deliver_password_reset_instructions!
      flash[:notice] = 'Instructions to reset your password have been emailed.'
      render :template => '/customer/password_resets/confirmation'
    else
      @user          = User.new
      flash[:notice] = 'No user was found with that email address'
      render :action => 'new'
    end
  end

  def edit
    #render
    puts "edit user=>#{@user.inspect}"
  end

  def update
    puts "update user=>#{@user.inspect}"
    @user.password              = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      #@user.activate!
      flash[:notice] = 'Your password has been reset'
      redirect_to login_url
    else
      render :action => :edit
    end
  end

  protected

  def load_user_using_perishable_token
    puts "params=>#{params.inspect}"
    token = (params[:perishable_token] or params[:user][:perishable_token])
    @user = User.find_by_perishable_token(token)
  end

end
