require Rails.root.join('lib', 'get_face.rb').to_s

class MyStudioSeeds

  def self.seeds(seed_path)
    file_to_load = seed_path.join('studios.yml').to_s
    image_path   = Rails.root.join('public', 'studios')
    studios      = YAML::load(File.open(file_to_load))[:studios]
    #get_face     = GetFace.new

    studios.each do |my_studio_attrs|

      if Studio.find_by_name(my_studio_attrs['name'])
        Studio.find_by_name(my_studio_attrs['name']).destroy
      end
      unless Studio.find_by_name(my_studio_attrs['name'])

        path = image_path.join(my_studio_attrs['name'].underscore.gsub(' ', '_'))
        path.mkpath unless path.directory?

        # create owner
        attrs = my_studio_attrs.delete('owner')
        owner = User.find_or_create_by_email(attrs['email'])
        owner.update_attributes(attrs.merge(:password => 'password'))

        # create Sessions
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
        my_studio.save
        puts "my_studio #{my_studio.name} errors=>#{my_studio.errors.full_messages}"
      end
    end
  end
end
