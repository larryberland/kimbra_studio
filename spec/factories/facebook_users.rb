# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :facebook_user do
    provider "MyString"
    uid "MyString"
    email "MyString"
    name "MyString"
    oauth_token "MyString"
    oauth_expires_at "2012-12-08 12:54:22"
  end
end
