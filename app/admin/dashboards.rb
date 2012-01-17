ActiveAdmin::Dashboards.build do

  section 'Recent Sessions' do
    table_for MyStudio::Session.by_studio(current_user.studio).within_seven_days.limit(5) do
      column :name do |session|
        link_to session.name, my_studio_session_path(session)
      end
      column 'Scheduled', :session_at
      column 'Portraits',:portraits do |session|
        if session.portraits.size < 2
          link_to 'Upload portraits', my_studio_session_portraits_path(session)
        else
          session.portraits.count.to_s
        end
      end
      column :emails do |session|
        session.emails.count > 0 ? link_to(session.emails.count.to_s, admin_admin_customer_email_path(session)) : ''
      end
      column '', :emails do |session|
        session.email_ready? ? link_to('Generate Email', generate_admin_customer_email_path(session.id), :method => :post) : ''
      end
    end
  end
  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
