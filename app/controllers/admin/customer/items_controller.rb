class Admin::Customer::ItemsController < InheritedResources::Base
  belongs_to :offer,
             :parent_class => Admin::Customer::Offer

end
