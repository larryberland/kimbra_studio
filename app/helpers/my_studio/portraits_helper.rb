module MyStudio::PortraitsHelper

  def feedback_for(portraits)
    return 'xxx' if portraits.blank? || portraits.size == 0
    msg = "You have uploaded #{portraits.size == 1 ? 'only 1 portrait' : "#{portraits.size} portraits"} so far. "
    msg << "<br/>We will generate an offer email with as few as 2 portraits but we prefer if you load at least 6 or as many as 20. "
    msg << "<br/>#{6 - portraits.size} to go." unless portraits.size >= 6
    msg.html_safe
  end

end