class PicturesController < ApplicationController

  before_filter :load_my_studio_session

  def index
    @pictures = Picture.where('my_studio_session_id=?', @my_studio_session).order('created_at desc')
    #@pictures = Picture.all.order('created_at desc')
    render :json => @pictures.collect { |p| p.to_jq_upload }.to_json
  end

  def create
    p_attr = params[:picture]
    p_attr[:avatar] = params[:picture][:file].first if params[:picture][:file].class == Array

    @picture = Picture.new(p_attr)
    if @picture.save
      respond_to do |format|
        format.html {
          render :json => [@picture.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json {
          render :json => [@picture.to_jq_upload].to_json
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    render :json => true
  end

  private #=====================================================================================

  def load_my_studio_session
    @my_studio_session = MyStudio::Session.find(params[:session_id]) if params[:session_id]
  end

end