class CreateShippingOptions < ActiveRecord::Migration

  def change
    create_table :shipping_options, :force => true do |f|
      f.string :name
      f.string :description
      f.integer :cost_cents
      f.integer :sort_order
      f.timestamps
    end

    # Add real shipping options.
    [['Regular Ground Shipping USA', 995, 'Travel time is 3 to 5 business days.'],
     ['2nd Day Air Shipping USA', 2495, 'Travel time is 2 business days.'],
     ['Next Day Air Shipping USA', 3295, 'Travel time is overnight.'],
     ['Alaska Shipping', 2500, 'Delivery to Alaska.'],
     ['Canada Shipping', 2695, 'Delivery to Canada.'],
     ['Hawaii Shipping', 2500, 'Delivery to Hawaii.'],
     ['Mexico Shipping', 3295, 'Delivery to Mexico.'],
     ['Outside USA, Mexico and Canada', 4800, 'Delivery to most countries outside North America. ' +
         'Some countries are excluded. We\'ll contact you if there\'s a problem.']].each_with_index do |item, index|
      ShippingOption.create :name => item.first, :cost_cents => item.second, :description =>item.last, :sort_order => index
    end
  end

end