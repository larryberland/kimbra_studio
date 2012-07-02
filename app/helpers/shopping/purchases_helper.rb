module Shopping::PurchasesHelper

  # Does not handle an empty hash or nil argument.
  def tax_text(tax_description)
    if tax_description.present?
      "Zipcode: #{tax_description[:zip_code]} " + '<br/>' +
          "Taxable amount: #{tax_description[:taxable_amount]}" + '<br/>' +
          "State: #{tax_description[:state]}" + '<br/>' +
          "Region: #{tax_description[:region]}" + '<br/>' +
          "Code: #{tax_description[:code]}" + '<br/>' +
          "Combined tax rate: #{tax_description[:combined_tax][:rate]} Amount: #{tax_description[:combined_tax][:amount]}" + '<br/>' +
          "State tax rate: #{tax_description[:state_tax][:rate]} Amount: #{tax_description[:state_tax][:amount]}" + '<br/>' +
          "County tax rate:#{tax_description[:county_tax][:rate]} Amount: #{tax_description[:county_tax][:amount]}" + '<br/>' +
          "City tax: #{tax_description[:city_tax][:rate]} Amount: #{tax_description[:city_tax][:amount]}" + '<br/>' +
          "Special tax rate: #{tax_description[:special_tax][:rate]} Amount: #{tax_description[:special_tax][:amount]}".html_safe
    else
      ''
    end
  end

end