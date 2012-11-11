module MyStudio::SessionsHelper

  def upload_link(session)
    url   = my_studio_session_portraits_path(session)
    name = session.portraits.count.to_words
    return link_to(name, url, title: 'View Session Portraits') if is_admin?
    html_options = {method: :get, class: "btn btn-success"}
    if (session.finished_uploading_at)
      # studio has marked this as finished so no more uploading
      link_to name, url, title: 'View Session Portraits'
    else
      case session.portraits.count
        when 0
          button_to t(:my_studio_sessions_upload_now_link), url, html_options
        when 1..MyStudio::Session::MIN_PORTRAITS
          button_to t(:my_studio_sessions_upload_more_link), url, html_options
        else
          link_to name, url, title: 'View Session Portraits'
      end
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
      #session.finished_uploading_at? ?  : button_to(t(:my_studio_portraits_new_link), my_studio_session_portraits_path(session), {method: :get, class: "btn btn-primary"})
      if (session.finished_uploading_at?)
        '&#x2713;'.html_safe
      else
        if (session.complete?)
          button_to(t(:my_studio_sessions_complete_link),
                    my_studio_session_is_finished_uploading_portraits_path(session),
                    {method: :get, class: "btn btn-primary", title: t(:my_studio_sessions_complete_title)})
        else
          "Recommend #{MyStudio::Session::BEST_PORTRAITS} portraits to complete."
        end

      end

    end
  end

end