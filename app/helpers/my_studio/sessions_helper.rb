module MyStudio::SessionsHelper

  def upload_link(session)
    return link_to(session.portraits.count.to_words, my_studio_session_portraits_path(session), title: 'View Session Portraits') if is_admin?
    case  session.portraits.count
      when 0
        button_to "Upload Portraits Now!", my_studio_session_portraits_path(session), method: :get
      when 1..4
        button_to "Upload more portraits", my_studio_session_portraits_path(session), method: :get
      else
        link_to session.portraits.count.to_words, my_studio_session_portraits_path(session), title: 'View Session Portraits'
    end
  end

  def complete?(session)
    if is_admin?
      if session.finished_uploading_at?
        content_tag :span, title: "#{time_short session.finished_uploading_at}" do
          '&#x2713;'.html_safe
        end
      else
        '&#x2718;'.html_safe
      end
    else
      session.finished_uploading_at? ? '&#x2713;'.html_safe : button_to(t(:my_studio_portraits_new_link), my_studio_session_portraits_path(session), method: :get)
    end
  end

end