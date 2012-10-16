ActiveAdmin.register Studio do

  filter :state, as: :select
  filter :city
  filter :eap_click
  filter :sales_status

  config.sort_order = "name_asc"

  index do
    column :id
    column 'Logo' do |studio|
      image_tag_thumb(studio.minisite)
    end

    column 'EAP', sortable: :eap_click do |studio|
      if studio.eap_click
        span title: time_short_index(studio.eap_click) do
          date_short studio.eap_click
        end
      else
        eap_link(studio)
      end
    end

    column :name, sortable: :name do |studio|
      studio_email_link(studio)
    end

    column :owner, sortable: :'users.first_name' do |studio|
      user_email_link(studio.owner)
    end

    column 'Website' do |studio|
      link_from_site_short_name(studio.info.try(:website))
    end

    column :phone_number do |studio|
      number_to_phone studio.phone_number, area_code: true
    end

    column 'Location' do |studio|
      studio.city_state_name
    end

    column 'Sales status', sortable: :sales_status do |studio|
      span title: studio.sales_notes do
        studio.sales_status
      end
    end

    column 'Actions' do |studio|
      active_admin_actions_link(studio)
    end

    # Member methods
    # publish_admin_studio_(path|url)
    # /admin/studio/:id/publish
    #member_action :impersonate do
    #  studio = Studio.find(params[:id])
    #  redirect_to "/switch_user?scope_identifier=user_#{studio.owner.id}" if studio.owner
    #end

  end

  controller do
    def new
      @studio = Studio.new(info: MyStudio::Info.new,
                           minisite: MyStudio::Minisite.new)
      attrs = {first_pass: User.generate_random_text}
      attrs[:password] = attrs[:first_pass]
      @studio.build_owner(attrs)
      @states = State.form_selector
      render partial: 'studios/form'
    end

    def scoped_collection
      end_of_association_chain.includes(:owner)
    end
  end

end