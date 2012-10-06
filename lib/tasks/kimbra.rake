namespace 'kimbra' do

  desc "Send unsent offer emails"
  task :send_offers => :environment do
    Admin::Customer::Email.send_offer_emails
  end

  desc "Seed Studios from Kimbra Spreadsheet. Use: [n] to add next n rows. Defaults to 10."
  task :seed_studio_owners, [:rows_to_add] => :environment do |t,args|
    require 'csv'
    last_row_added = User.maximum(:csv_row).to_i
    args.with_defaults rows_to_add: 10
    CSV.open('kimbra_studios.csv', "r", headers: true).each_with_index do |row, idx|
      csv_row = idx + 2
      # Skip over spreadsheet rows we already loaded.
      next unless csv_row > last_row_added
      # Only add the requested number of rows.
      break if csv_row >= last_row_added + args.rows_to_add.to_i + 1
      attrs   = {csv_row:             csv_row,
                 address_1:           row["BADDR2"],
                 address_2:           row["BADDR3"],
                 phone_number:        row["PHONE1"],
                 country_abbrev:      row["BADDR5"].to_s.strip.upcase,
                 minisite_attributes: {bgcolor:     '#2a1907',
                                       font_color:  '#d3b492',
                                       font_family: 'Arial'},
                 info_attributes:     {}}

      attrs[:name] = row["COMPANYNAME"] || row["NAME"] || row["CONT1"] || row["CONT2"]
      attrs[:name] = attrs[:name].to_s.titleize

      user_attrs = {email:      row["EMAIL"] || row["EMAIL2"],
                    address_1:  row['BADDR2'] || row['BADDR1'],
                    first_name: row["FIRSTNAME"],
                    last_name:  row["LASTNAME"],
                    joined_on:  "01/01/2012"}
      if (user_attrs[:email].present?)

        user_attrs[:email].downcase!

        user_attrs[:first_pass] = User.generate_random_text
        user_attrs[:password]   = user_attrs[:first_pass]
        user_attrs[:csv_row]    = csv_row

        if (row['JOINED'])
          on                     = row['JOINED'].strip.split('/')
          user_attrs[:joined_on] = "#{on[1]}/#{on[0]}/#{on[2]}" # d/m/year
        end

        attrs[:info_attributes][:website]         = row["WEBSITE"]
        attrs[:info_attributes][:tax_ein]         = row["TAX_ID"]
        attrs[:info_attributes][:commission_rate] = 10

        city_state_zip = row["BAADR4"].to_s.strip.upcase
        info           = city_state_zip.split(',')
        if (info.size != 2)
          puts "[#{csv_row}]city_state_zip:#{city_state_zip} url:#{row["WEBSITE"]} email:#{user_attrs[:email]}"
        end
        user_attrs[:raw_seed] = city_state_zip

        # parse city, state postal_code
        user_attrs[:city]     = info[0].strip
        state_and_zip         = info[1].strip.split(" ")
        state_name_or_abbrev  = state_and_zip.shift.strip
        user_attrs[:zip_code] = state_and_zip.join(" ").strip

        s = State.find_by_abbreviation(state_name_or_abbrev.upcase)
        s = State.find_by_name(state_name_or_abbrev.titleize) if s.nil?

        if (s.nil?)
          puts "[#{csv_row}] No State for state:#{state_name_or_abbrev} raw_seed:#{city_state_zip} url:#{row["WEBSITE"]} email:#{user_attrs[:email]}"
          next
        end
        user_attrs[:state] = s
        u                  = User.find_by_email(user_attrs[:email])
        result             = if (u.nil?)
                               u = User.new(user_attrs)
                               u.skip_confirmation!
                               u.save
                             else
                               on = user_attrs[:joined_on].to_date
                               puts ""
                               puts "[#{csv_row}] Duplicate email url:#{row["WEBSITE"]} email:#{user_attrs[:email]}"
                               puts "[#{csv_row}] prev:#{u.joined_on} row:#{u.csv_row} addr:#{u.formatted_address}"
                               puts "[#{csv_row}]  now:#{on} row:#{user_attrs[:csv_row]} addr:#{user_attrs[:raw_seed]}"
                               puts "[#{csv_row}] u:#{u.inspect}"
                               puts "[#{csv_row}] a:#{user_attrs.inspect}"
                               puts "[#{csv_row}] #{row.inspect}"


                               if (on > u.joined_on)
                                 puts "[#{csv_row}]update row"
                                 u.skip_confirmation!
                                 u.update_attributes(user_attrs)
                               else
                                 puts "[#{csv_row}]NOT updating"
                                 true
                               end
                             end
        if (result)

          # ready to create a studio for this user
          if (u.state)

            # lets create the studio
            attrs[:owner]    = u
            abbrev           = attrs.delete(:country_abbrev)
            attrs[:country]  = Country.find_by_abbreviation(abbrev)
            attrs[:state]    = u.state
            attrs[:city]     = u.city
            attrs[:zip_code] = u.zip_code

            studio = u.studio(true)
            result = if (studio.nil?)
                       studio = Studio.create(attrs)
                     else
                       studio.update_attributes(attrs)
                     end
            if (!result)
              puts "errors:#{studio.errors.full_messages}"
              puts "studio[#{csv_row}]:#{studio.inspect}"
              puts "studio[#{csv_row}]:#{row.inspect}"
            else
              puts "added [#{csv_row}] email:#{studio.owner.email} pwd:#{studio.owner.first_pass} id:#{studio.id} #{studio.name} "
            end
          else
            puts "fix_me"
            puts "NO State for user [#{csv_row}]:#{u.inspect}"
            puts "studio[#{csv_row}]:#{row.inspect}"
          end

        else
          puts "errors:#{u.errors.full_messages}"
          puts "user[#{csv_row}]: raw_seed:#{u.raw_seed}"
          puts "user[#{csv_row}]:#{row.inspect}"
        end

      else
        puts "INVALID email[#{idx}]"
        puts "studio[#{idx}]:#{row.inspect}"
      end

    end
    puts "all done now go make some money"
  end

  desc "Seed Studios from Kimbra Spreadsheet using gmap"
  task :seed_gmap_studios => :environment do
    require 'csv'
    file = Rails.root.join("config", "kimbra_studios.csv")

    CSV.open(file.to_s, "r", headers: true).each_with_index do |row, idx|

      attrs = {address_1:           row["BADDR2"],
               address_2:           row["BADDR3"],
               phone_number:        row["PHONE1"],
               minisite_attributes: {bgcolor:     '#2a1907',
                                     font_color:  '#d3b492',
                                     font_family: 'Arial'},
               info_attributes:     {}}

      attrs[:name] = row["COMPANYNAME"] || row["NAME"] || row["CONT1"] || row["CONT2"]


      user_attrs = {email:      row["EMAIL"] || row["EMAIL2"],
                    address_1:  row['BADDR2'] || row['BADDR1'],
                    first_name: row["FIRSTNAME"],
                    last_name:  row["LASTNAME"],
                    password:   User.generate_random_text}
      if (user_attrs[:email].present?)

        attrs[:info_attributes][:website]         = row["WEBSITE"]
        attrs[:info_attributes][:tax_ein]         = row["TAX_ID"]
        attrs[:info_attributes][:commission_rate] = 10

        add3           = row["BADDR3"].to_s.strip.upcase
        add4           = row["BAADR4"].to_s.strip.upcase
        city_state_zip = add3 + "#{add3} #{add4}".gsub(add3, '')
        city_state_zip.strip!
        if (city_state_zip == 'TEMECULA, CA  00000')
          city_state_zip = 'TEMECULA, CA  92590'
        end
        user_attrs[:raw_seed]       = city_state_zip

                                      # country abbrev
        user_attrs[:country_abbrev] = row["BADDR5"].to_s.strip.upcase

        user_attrs[:email].downcase!
        attrs[:owner] = User.find_by_email(user_attrs[:email]) || User.new(user_attrs)
        attrs[:owner].skip_confirmation!
        attrs[:owner].use_gmap = true # use address info from gmap
        result                 = if (!attrs[:owner].new_record?)
                                   attrs[:owner].update_attributes(user_attrs)
                                 else
                                   attrs[:owner].save
                                 end

        if (!result)
          puts "errors:#{attrs[:owner].errors.full_messages}"
          puts "c_s_zip:#{city_state_zip}"
          puts "user[#{idx}]:#{attrs[:owner].raw_seed}"
          puts "user[#{idx}]:#{attrs[:owner].city}"
          puts "user[#{idx}]:#{row.inspect}"
        else
          u = attrs[:owner]
          puts "#{u.email} city:#{u.city} state:#{u.state} address:#{u.raw_seed}"
        end
      else
        puts "INVALID email[#{idx}]"
        puts "studio[#{idx}]:#{row.inspect}"
      end
      #if idx > 1
      #  break
      #end
    end
    puts "all done now go make some money"
  end


end