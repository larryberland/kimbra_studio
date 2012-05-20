class TrackingController < ApplicationController

  skip_before_filter :authenticate_user!

  # Used to track opening of emails.
  def image
    Admin::Customer::Email.find_by_tracking(params[:id]).update_attribute(:opened_at, Time.now) if params[:id]
    send_file File.join(Rails.root, "/app/assets/images/spacer.gif"), :type => 'image/gif', :disposition => 'inline'
  end

end