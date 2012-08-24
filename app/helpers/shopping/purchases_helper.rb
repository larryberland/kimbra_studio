module Shopping::PurchasesHelper

  # Does not handle an empty hash or nil argument.
  def tax_text(tax_description)
    if tax_description.present?
      result = "<table border=0>" +
          "<tr>" +
          "<th>&nbsp;</th><th>Zipcode</th><th>State</th><th>Region</th><th>Code</th><th align='right'>Taxable Amount</th>" +
          "</tr>" +
          "<tr>" +
          "<td>&nbsp;</td>" +
          "<td>#{tax_description[:zip_code]}</td>" +
          "<td>#{tax_description[:state]}</td>" +
          "<td>#{tax_description[:region]}</td>" +
          "<td>#{tax_description[:code]}</td>" +
          "<td align='right'>#{tax_description[:taxable_amount]}</td>" +
          "</tr>" +
          "</table>" +
          "<br/>"
          "<table border=0>" +
          "<tr>" +
          "<th>&nbsp;</th><th align='right'>Combined</th><th align='right'>State Rate</th><th align='right'>County Rate</th><th align='right'>City Rate</th><th align='right'>Special Rate</th>" +
          "</tr>" +
          "<tr>" +
          "<td>Rate</td>" +
          "<td align='right'>#{tax_description[:combined_tax][:rate]}%</td>" +
          "<td align='right'>#{tax_description[:state_tax][:rate]}%</td>" +
          "<td align='right'>#{tax_description[:county_tax][:rate]}%</td>" +
          "<td align='right'>#{tax_description[:city_tax][:rate]}%</td>" +
          "<td align='right'>#{tax_description[:special_tax][:rate]}%</td>" +
          "</tr>" +
          "<tr>" +
          "<td>Amount</td>" +
          "<td align='right'>$#{tax_description[:combined_tax][:amount]}</td>" +
          "<td align='right'>$#{tax_description[:state_tax][:amount]}</td>" +
          "<td align='right'>$#{tax_description[:county_tax][:amount]}</td>" +
          "<td align='right'>$#{tax_description[:city_tax][:amount]}</td>" +
          "<td align='right'>$#{tax_description[:special_tax][:amount]}</td>" +
          "</tr>" +
          "</table>"
    else
      result = ''
    end
    result.html_safe
  end

end