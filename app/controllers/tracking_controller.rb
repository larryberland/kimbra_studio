class TrackingController < ApplicationController

  skip_before_filter :authenticate_user!

  # Used to track opening of emails.
  def image
    if params[:id]
      if email = Admin::Customer::Email.find_by_tracking(params[:id])
        email.update_attribute(:opened_at, Time.now)
        send_file File.join(Rails.root, "/app/assets/images/spacer.gif"), :type => 'image/gif', :disposition => 'inline'
      end
    end
  end

end