module MyStudio::PortraitsHelper

  def feedback_for(count)
    text = t(:my_studio_portraits_feedback_common,
             min:  MyStudio::Session::MIN_PORTRAITS,
             best: MyStudio::Session::BEST_PORTRAITS,
             max:  MyStudio::Session::MAX_PORTRAITS)
    if count == 0
      msg = text
      msg = "Click the Add Portraits button to begin uploading six or more of your client's portraits."
    else
      msg = "You have uploaded #{count == 1 ? 'only 1 portrait' : "#{count} portraits"} so far. "
      msg << "<br/>#{text}"
      msg << "<br/> <i class='icon-hand-right'> </i> #{MyStudio::Session::BEST_PORTRAITS - count} to go." unless count >= MyStudio::Session::BEST_PORTRAITS
    end
    msg.html_safe
  end

  def empty_table_rows
    '<tr><td>No portraits uploaded yet.</td></tr>'.html_safe
  end

  def what_is_going_on
    "<span><i class='icon-thumbs-up'></i>Some Text#{my_button}</span>".html_safe
  end

  def button_to_with_icon(button_to_html, icon_class=nil)
    icon_class ||= 'icon-ok-sign icon-white'
    # add a span with icon to the div
    html = button_to_html.gsub('<div><input', "<div><span class='btn btn-success'><i class='#{icon_class}'></i><input")
    html.gsub!('</div>', '</span></div>')
    html.html_safe
  end

  def actions_for_portraits(my_studio_session)
    if my_studio_session.finished_uploading_at?
      'You marked this photo session as complete and it has been scheduled for photoshopping.'
    elsif my_studio_session.complete?
      html = button_to(t(:my_studio_sessions_complete_link2, portrait_count: my_studio_session.portraits.count),
                    my_studio_session_is_finished_uploading_portraits_path,
                    {method: :get, class: "btn btn-success", title: t(:my_studio_sessions_complete_title)})
      button_to_with_icon(html)
    end
  end

  def alert_type_for(count)
    case
      when count < MyStudio::Session::MIN_PORTRAITS
        'alert-error'
      when count < MyStudio::Session::BEST_PORTRAITS
        'alert-info'
      when count >= MyStudio::Session::BEST_PORTRAITS && count <= MyStudio::Session::MAX_PORTRAITS
        'alert-success'
      when count > MyStudio::Session::MAX_PORTRAITS
        'alert-error'
      else
        'alert-error'
    end
  end

end