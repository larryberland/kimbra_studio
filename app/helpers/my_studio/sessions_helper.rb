module MyStudio::SessionsHelper

  def upload_link(session)
    case  session.portraits.count
      when 0
        button_to "Upload Portraits Now!", new_my_studio_session_portrait_path(session), method: :get
      when 1..4
        button_to "Upload more portraits", new_my_studio_session_portrait_path(session), method: :get
      else
        link_to session.portraits.count.to_words, my_studio_session_portraits_path(session), title: 'View Session Portraits'
    end
  end

end