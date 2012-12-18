class MyStudio::BaseController < ApplicationController

  private

  def navbar_active
    @navbar_active = :collection
  end
end