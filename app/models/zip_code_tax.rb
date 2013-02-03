class ZipCodeTax < ActiveRecord::Base

  def self.invoice_tax(zip_code_5_digit, taxable_sub_total)
    raise "we need a zip_code to figure this?" if zip_code_5_digit.nil?
    tax             = 0
    tax_description = Hash.new(
        taxable_amount: taxable_sub_total,
        zip_code:       zip_code_5_digit,
        state:          zip_code_5_digit,
        region:         '',
        code:           '',
        combined_tax:   {rate: 0, amount: 0},
        state_tax:      {rate: 0, amount: 0},
        county_tax:     {rate: 0, amount: 0},
        city_tax:       {rate: 0, amount: 0},
        special_tax:    {rate: 0, amount: 0})
    if tax_rate = find_by_zip_code(zip_code_5_digit)
      state_tax       = (taxable_sub_total * tax_rate.state_rate).round(2)
      county_tax      = (taxable_sub_total * tax_rate.county_rate).round(2)
      city_tax        = (taxable_sub_total * tax_rate.city_rate).round(2)
      special_tax     = (taxable_sub_total * tax_rate.special_rate).round(2)
      combined_tax    = state_tax + county_tax + city_tax + special_tax
      tax_description = {
          zip_code:       tax_rate.zip_code,
          taxable_amount: taxable_sub_total,
          state:          tax_rate.state,
          region:         tax_rate.tax_region_name,
          code:           tax_rate.tax_region_code,
          combined_tax:   {rate: tax_rate.combined_rate, amount: combined_tax},
          state_tax:      {rate: tax_rate.state_rate, amount: state_tax},
          county_tax:     {rate: tax_rate.county_rate, amount: county_tax},
          city_tax:       {rate: tax_rate.city_rate, amount: city_tax},
          special_tax:    {rate: tax_rate.special_rate, amount: special_tax}
      }
      tax             = combined_tax
    end
    return tax, tax_description
  end
end