module MyStudio::PortraitsHelper

  def feedback_for(count)
    text = t(:my_studio_portraits_feedback_common,
                   min:  MyStudio::Session::MIN_PORTRAITS,
                   best: MyStudio::Session::BEST_PORTRAITS,
                   max:  MyStudio::Session::MAX_PORTRAITS)
    if count == 0
      msg = text
    else
      msg = "You have uploaded #{count == 1 ? 'only 1 portrait' : "#{count} portraits"} so far. "
      msg << "<br/>#{text}"
      msg << "<br/>#{MyStudio::Session::BEST_PORTRAITS - count} to go." unless count >= MyStudio::Session::BEST_PORTRAITS
    end
    msg.html_safe
  end

  def empty_table_rows
    '<tr><td>No portraits uploaded yet.</td></tr>'.html_safe
  end

  def actions_for_portraits(my_studio_session)
    if my_studio_session.finished_uploading_at?
      'You marked this photo session as complete and it has been scheduled for photoshopping.'
    elsif my_studio_session.complete?
      button_to('Process my email! I have uploaded a good selection of portraits.',
                my_studio_session_is_finished_uploading_portraits_path,
                {method: :get, class: "btn btn-success"})
    end
  end

end