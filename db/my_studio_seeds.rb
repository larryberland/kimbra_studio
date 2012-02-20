require Rails.root.join('lib', 'get_face.rb').to_s

class MyStudioSeeds

  def self.seeds(seed_path)
    file_to_load = seed_path.join('studios.yml').to_s
    image_path   = Rails.root.join('public', 'studios')
    studios      = YAML::load(File.open(file_to_load))[:studios]
    #get_face     = GetFace.new

    studios.each do |my_studio_attrs|
      puts "processing #{my_studio_attrs['name']}"
      if Studio.find_by_name(my_studio_attrs['name'])
        Studio.find_by_name(my_studio_attrs['name']).destroy
        puts "destroyed #{my_studio_attrs['name']}"
      end
      unless Studio.find_by_name(my_studio_attrs['name'])
        path = image_path.join(my_studio_attrs['name'].underscore.gsub(' ', '_'))
        path.mkpath unless path.directory?

        # delete owner if exists and create owner afresh
        attrs = my_studio_attrs.delete('owner')
        if old_owner = User.find_by_email(attrs['email'])
          old_owner.destroy
          puts "destroyed #{attrs['email']}"
        end
        password = 'password'
        owner = User.create(attrs.merge(:password => password))
        if owner.errors.blank?
          puts "created owner #{owner.email} and added her password"
        else
          puts "failed to create owner: #{owner.errors.full_messages.join(', ')}"
          break
        end

        # create minisite details
        attrs = my_studio_attrs.delete('minisite')
        minisite = MyStudio::MiniSite.create(attrs)
        if minisite.errors.blank?
          puts "created minisite"
        else
          puts "failed to create minisite"
        end

        # create Sessions
        puts "now creating sessions"
        index                  = 0
        sessions               = my_studio_attrs.delete('sessions').collect do |session_attrs|
          index  += 1
          client = MyStudio::Client.create(session_attrs.delete('client'))
          puts "mystudio client=>#{client.email}"

          # load portraits
          client_path = path.join(client.name.underscore.gsub(' ', '_'))
          client_path.mkpath unless client_path.directory?
          portraits = client_path.children.collect do |p|
            if p.file?
              if File.basename(p).split('.').last.match(/JPG|jpg/)
                portrait = MyStudio::Portrait.create
                portrait.image.store!(File.open(p.to_s))
                portrait.save
                #get_face.perform(portrait) # process for faces
                portrait
              end
            end
          end

          portraits.compact! unless portraits.nil?

          s = MyStudio::Session.create(session_attrs.merge(:client => client, :session_at => index.days.ago))
          s.portraits = portraits unless portraits.nil?
          s.category = Category.find_by_name(session_attrs['name'])
          s.save
          s
        end

        # tie them all up into studio
        my_studio              = Studio.new(my_studio_attrs)
        my_studio.current_user = owner
        my_studio.owner        = owner
        my_studio.sessions     = sessions
        my_studio.minisite     = minisite
        if my_studio.save
          puts "Finished!Created studio: #{my_studio.name}, with owner: #{my_studio.owner.first_name} #{my_studio.owner.last_name} (login with #{my_studio.owner.email}/#{password}) and background: #{my_studio.minisite.bgcolor}"
          puts "Don't forget to activate the owner using the activation URL spat out earlier in this seeds job."
        else
          puts "CRAP! my_studio #{my_studio.name} errors=>#{my_studio.errors.full_messages.join(', ')}"
        end
      end
    end
  end; true
end