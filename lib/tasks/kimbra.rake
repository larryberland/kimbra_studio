namespace 'kimbra' do

  desc "Send unsent offer emails"
  task :send_offers => :environment do
    Admin::Customer::Email.send_offer_emails
  end

  desc "Seed Studios from Kimbra Spreadsheet using gmap"
  task :seed_studio_owners => :environment do
    require 'csv'
    file = Rails.root.join("config", "kimbra_studios.csv")

    CSV.open(file.to_s, "r", headers: true).each_with_index do |row, idx|

      csv_row = idx + 2
      attrs   = {address_1:           row["BADDR2"],
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
      if idx > 2
        break
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

  desc "Seed Studios from Kimbra Spreadsheet"
  task :seed_studios => :environment do
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
                    first_name: row["FIRSTNAME"],
                    last_name:  row["LASTNAME"],
                    password:   User.generate_random_text}
      if (user_attrs[:email].present?)
        user_attrs[:email].downcase!

        attrs[:owner] = User.find_by_email(user_attrs[:email]) || User.new(user_attrs)
        attrs[:owner].skip_confirmation!

        attrs[:info_attributes][:website]         = row["WEBSITE"]
        attrs[:info_attributes][:tax_ein]         = row["TAX_ID"]
        attrs[:info_attributes][:commission_rate] = 10

        add3 = row["BADDR3"].to_s.strip.upcase
        add4 = row["BAADR4"].to_s.strip.upcase

        if (add3.starts_with?('SUITE'))
          add3 = ''
        elsif (add3.starts_with?('P.'))
          add3 = ''
        elsif (add3.starts_with?('P0 BOX'))
          add3 = ''
        elsif (add3.starts_with?('BOX'))
          add3 = ''
        elsif (add3.starts_with?('APT'))
          add3 = ''
        elsif (add3.starts_with?('S.'))
          add3 = ''
        elsif (add3.starts_with?('4321'))
          add3 = ''
        elsif (add3.starts_with?('2525'))
          add3 = ''
        elsif (add3.starts_with?('8660'))
          add3 = ''
        elsif (add3.starts_with?('501'))
          add3 = ''
        elsif (add3.starts_with?('13500'))
          add3 = ''
        elsif (add3.starts_with?('2295'))
          add3 = ''
        elsif (add3.starts_with?('23316'))
          add3 = ''
        elsif (add3.starts_with?('#'))
          add3 = ''
        elsif (add3.starts_with?('TAKE'))
          add3 = ''
        elsif (add3.starts_with?('UNIT'))
          add3 = ''
        elsif (add3.starts_with?('STUDIO'))
          add3 = ''
        elsif (add3 == 'WATERLOO, ONTARIO N2V2X2')
          add3 = "WATERLOO,"
        end

        # what if i didn't use add3 at all
        add3 = ''

        case add4
          when 'ORANGE PARK, FL  32003'
            city_state_zip = add4
          when 'PRINCE GEORGE PRINCE GEORGE V2M 7C9'
            city_state_zip = 'PRINCE GEORGE, BC V2M 7C9'
          when 'BEVERLY HILLS, CA  90211'
            city_state_zip = add4
          when 'LAKESIDE, CA  92040'
            city_state_zip = add4
          else
            # this will remove duplication in add3 and add4
            city_state_zip = add3 + "#{add3} #{add4}".gsub(add3, '')
        end

        case city_state_zip
          when '1320 COMMONWEALTH DR, KINGS BEACH, CA 96148 TAHOE VISTA, CA  96148'
            city_state_zip = add4
        end

        city_state_zip.strip!

        info = []
        if (city_state_zip)
          pass1 = city_state_zip.split(',')

          if (pass1[1].nil?)
            pass1 = city_state_zip.split('/')
            if (pass1.size < 2)
              info = city_state_zip.split(' ')
            else
              info << pass1[0]
              info << pass1[1].split(' ')
            end
          else
            info << pass1[0]
            info << pass1[1].split(' ')
          end
        end

        info.flatten!
        if (!add3.blank?)
          puts ""
          puts "[#{idx}] add3=>#{add3.inspect}"
          puts "[#{idx}] add4=>#{add4.inspect}"
          puts "[#{idx}] info=>#{info.inspect}"
        end

        state = nil
        city  = ''
        zip   = ''

        if (info.size>1)

          cities = []
          zips   = []

          info.each_with_index do |data, idx|

            if (state)
              zips << data # should be zip code data
            else
              state_abbrev_or_name = data
              state_abbrev_or_name = 'BC' if state_abbrev_or_name == 'B.C.'
              state_abbrev_or_name = 'QC' if (state_abbrev_or_name.starts_with?('QU') and state_abbrev_or_name.ends_with?('BEC'))
              state = State.find_by_abbreviation(state_abbrev_or_name)
              if (state.nil?)
                state = State.find_by_name(state_abbrev_or_name.titleize)
                if (state.nil?)
                  cities << data # should be city data
                end
              end
            end

          end

          city = cities.join(" ")
          zip  = zips.join(" ")

          if (city == "VANOUVER")
            city = "VANCOUVER"
          end

          if (state.nil?)
            # fix up known State issues
            case info[0]
              when 'VANCOUVER'
                city                 = info.shift
                state_abbrev_or_name = "BC"
                zip                  = info.join(" ")
              when 'SPRUCE'
                city                 = info.shift
                city                 += info.shift
                state_abbrev_or_name = 'AB'
                zip                  = info.join(" ")
              when 'TERRACE'
                city                 = info[0]
                state_abbrev_or_name = 'BC'
                zip                  = info[1]
              when 'BURLINGTON'
                city                 = info[0]
                state_abbrev_or_name = 'ON'
                zip                  = info[1]
              when 'MISSISSAUGA'
                city                 = info.shift
                state_abbrev_or_name = 'ON'
                zip                  = info.join(" ")
              when 'BEAUMONT'
                if (city == 'BEAUMONT T4X0B4')
                  city                 = info.shift
                  state_abbrev_or_name = 'AB'
                  zip                  = info.join(" ")
                end
              when 'CALEDONIA'
                city                 = info.shift
                state_abbrev_or_name = 'ON'
                zip                  = info.join(" ")
              when 'WATERLOO'
                if (city == 'WATERLOO LIVERPOOL L22 3XG')
                  city = info.shift
                  info.shift
                  state_abbrev_or_name = 'FL'
                  zip                  = info.join(" ")
                end
              when 'SAINT-LAZARE'
                if (city == 'SAINT-LAZARE J7T3C2')
                  city                 = info.shift
                  state_abbrev_or_name = 'QC'
                  zip                  = info.join(" ")
                end
              when 'OTTAWA'
                if (city == 'OTTAWA K1K 3X2')
                  city                 = info.shift
                  state_abbrev_or_name = 'ON'
                  zip                  = info.join(" ")
                end
              when 'CENTRAL'
                if (city == 'CENTRAL NA')
                  city                 = info.shift
                  state_abbrev_or_name = 'Hong kong'
                  zip                  = info.join(" ")
                end
              when 'SOUTHAMPTON'
                if (city == 'SOUTHAMPTON SN02')
                  city                 = info.shift
                  state_abbrev_or_name = 'Bermuda'
                  zip                  = info.join(" ")
                end
              when 'PARADISE'
                if (city == 'PARADISE A1L 2J6')
                  city                 = info.shift
                  state_abbrev_or_name = 'NL'
                  zip                  = info.join(" ")
                end
              when 'DARTFORD'
                if (city == 'DARTFORD DA1 1HD')
                  country              = Country.find_by_name('GBR')
                  city                 = info.shift
                  state_abbrev_or_name = 'UK'
                  zip                  = info.join(" ")
                end
              else
                puts ""
                puts "fix_me"
                puts "add3[#{add3}]"
                puts "add4[#{add4}]"
                puts "#{idx} #{info.inspect}"
                puts "#{idx} city:#{city} zip:#{zip} state:#{state.inspect}"
            end
          else
            state_abbrev_or_name = state.abbreviation
          end
        end

        if (city and state_abbrev_or_name)

          abbrev           = state_abbrev_or_name
          attrs[:city]     = city
          attrs[:zip_code] = zip

          if (abbrev.ends_with?('BEC'))
            puts "convert utf16 #{state}=>'QC'"
            abbrev = 'QC'
          end

          state = State.find_by_abbreviation(abbrev)
          state = State.find_by_name(abbrev.titleize) if state.nil?

          if (state.nil?)
            puts "missing State:#{abbrev} city:#{city} zip:#{zip}"
            puts "[#{idx}]:city_state_zip=>#{city_state_zip}"
            puts "[#{idx}]:#{row.inspect}"
            attrs[:address_1] = '1856 Stevenson Ave'
            attrs[:city]      = 'Clearwater'
            attrs[:zip_code]  = '33755'
            state             = State.find_by_abbreviation('FL')
          end
        else
          puts "missing city and State:#{state_abbrev_or_name} city:#{city} zip:#{zip}"
          puts "[#{idx}]:city_state_zip=>#{city_state_zip}"
          puts "[#{idx}]:#{row.inspect}"
          attrs[:address_1] = '1856 Stevenson Ave'
          attrs[:city]      = 'Clearwater'
          attrs[:zip_code]  = '33755'
          state             = State.find_by_abbreviation('FL')
        end

        attrs[:state_id] = state.id if state

        studio = if (attrs[:owner].new_record?)
                   s = Studio.create(attrs)
                   s
                 else
                   if (attrs[:owner].studio(true).present?)
                     # attrs[:owner].studio.update_attributes(attrs)
                     attrs[:owner].studio
                   else
                     s = Studio.create(attrs)
                     s
                   end
                 end
        if (studio.errors.present?)
          puts "INVALID studio[#{idx}]:#{studio.errors.full_messages}"
          puts "c_s_zip:#{city_state_zip}"
          puts "studio[#{idx}]:#{city}/#{state}/#{zip}"
          puts "studio[#{idx}]:#{studio.inspect}"
          puts "studio[#{idx}]:#{row.inspect}"
        end
      else
        puts "INVALID email[#{idx}]"
        puts "studio[#{idx}]:#{row.inspect}"
      end
    end
    puts "all done now go make some money"
  end

end