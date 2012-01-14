class MyStudio::Client < ActiveRecord::Base
  belongs_to :address
  has_many  :sessions, :class_name => 'MyStudio::Session', :dependent => :destroy
end
