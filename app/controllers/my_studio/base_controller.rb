class MyStudio::BaseController < ApplicationController
  before_filter :navbar_active

  private

  def navbar_active
    @navbar_active = :collection
  end
end