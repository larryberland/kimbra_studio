class MyStudio::Client < ActiveRecord::Base
  has_many  :sessions, :class_name => 'MyStudio::Session', :dependent => :destroy
end
