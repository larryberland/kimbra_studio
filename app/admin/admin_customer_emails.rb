ActiveAdmin.register Admin::Customer::Email do

  show do
    column 'Session', :my_studio_session do |email|
      email.my_studio_session.name
    end
    column 'Client',  :my_studio_session do |email|
      email.my_studio_session.client.name
    end
  end

  index do
    column :id
    column 'Session', :my_studio_session do |email|
      email.my_studio_session.name
    end
    column 'Client',  :my_studio_session do |email|
      email.my_studio_session.client.name
    end
    column :offers do |email|
      email.offers.size.to_s
    end
    column 'Created', :generated_at
    column 'Sent', :sent_at
    column 'Read', :opened_at
    column 'Click-Through', :visited_at
    default_actions

  end
end
