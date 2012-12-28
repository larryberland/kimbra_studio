class MigrateStudioClickThrusToStudioEmailsTable < ActiveRecord::Migration

  def up
    if Studio.content_columns.collect(&:name).include?('tkg_click')
      Studio.all.each do |studio|
        StudioEmail.create(studio: studio, email_name: 'studio_tkg_email', clicked_through_at: studio.tkg_click) if studio.tkg_click rescue nil
        StudioEmail.create(studio: studio, email_name: 'studio_xms_email', clicked_through_at: studio.xms_click) if studio.xms_click rescue nil
        StudioEmail.create(studio: studio, email_name: 'studio_eap_email', clicked_through_at: studio.eap_click) if studio.eap_click rescue nil
      end

      remove_column :studios, :tkg_click
      remove_column :studios, :xms_click
      remove_column :studios, :eap_click
    end

    SentEmail.all.each do |sent|
      owner = User.where(email: sent.email).first
      if owner
        if owner.studio
          puts studio.name
          StudioEmail.create(studio: owner.studio, email_name: 'studio_tkg_email', sent_at: sent.created_at) if sent.subject.match(/TKG/)
          StudioEmail.create(studio: owner.studio, email_name: 'studio_xms_email', sent_at: sent.created_at) if sent.subject.match(/XMS/)
          StudioEmail.create(studio: owner.studio, email_name: 'studio_eap_email', sent_at: sent.created_at) if sent.subject.match(/EAP/)
        end
      end
    end

  end

end