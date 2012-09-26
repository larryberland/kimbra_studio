namespace 'kimbra' do

  desc "Send unsent offer emails"
  task :send_offers => :environment do
    Admin::Customer::Email.send_offer_emails
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

        if (row["BAADR4"])
          info = row["BAADR4"].split(',')

          if (info.size < 2)
            info = row["BAADR4"].split('/') # Vancouver/BC V6R2L3
          end

          if (info.size < 2)
            info = row["BAADR4"].split(' ') # Vancouver V6R2L3
          end

          attrs[:city]     = info[0].strip
          state_and_zip    = info[1].strip.split(" ")
          #puts "city:#{attrs[:city]} state_and_zip=>#{state_and_zip.inspect}"

          state_abbrev     = state_and_zip.shift
          attrs[:zip_code] = state_and_zip.join(" ")

          abbrev = if (state_abbrev == 'Vancouver')
                     'BC'
                   elsif (state_abbrev == 'Ontario')
                     'ON'
                   elsif (state_abbrev == 'Manitoba')
                     'MB'
                   elsif (state_abbrev == 'b.c.')
                     'BC'
                   elsif (attrs[:city].downcase == 'manitoba')
                     attrs[:zip_code] = info[1].strip
                     'MB'
                   elsif (attrs[:city].downcase == 'vancouver')
                     attrs[:zip_code] = info[1].strip
                     'BC'
                   elsif (attrs[:city].downcase == 'quebec')
                     attrs[:zip_code] = info[1].strip
                     'QC'
                   else
                     state_abbrev
                   end
          state  = State.find_by_abbreviation(abbrev)
          if (state.nil?)
            puts "missing State:#{state_abbrev}"
          else
            attrs[:state_id] = state.id
          end

        else
          puts "[#{idx}] missing BAADR4 #{row.inspect}"
        end

        studio = if (attrs[:owner].new_record?)
                   s = Studio.create(attrs)
                   s
                 else
                   if (attrs[:owner].studio(true).present?)
                     attrs[:owner].studio.update_attributes(attrs)
                     attrs[:owner].studio
                   else
                     s = Studio.create(attrs)
                     s
                   end
                 end
        if (studio.errors.present?)
          puts "INVALID studio[#{idx}]:#{studio.errors.full_messages}"
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