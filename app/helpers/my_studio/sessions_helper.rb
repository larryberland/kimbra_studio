module MyStudio::SessionsHelper

  def upload_link(session)
    case  session.portraits.count
      when 0
        button_to "Upload Now!", new_my_studio_session_portrait_path(session), method: :get
      when 1..4
        button_to "Upload more", new_my_studio_session_portrait_path(session), method: :get
      else
        ''
    end
  end

end