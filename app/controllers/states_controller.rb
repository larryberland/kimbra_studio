class StatesController < ApplicationController
  respond_to :xml, :json
  
  def index
    @states = State.by_country(params[:country_id]).all if params[:country_id].present?
  end
end
