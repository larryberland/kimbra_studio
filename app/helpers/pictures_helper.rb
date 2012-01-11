module PicturesHelper
  def image_tag_thumb
    url = @studio_picture.image_url(:thumb).to_s rescue ''
    image_tag url
  end

  def image_tag_list(studio_picture)
    url = studio_picture.image_url(:list).to_s rescue ''
    image_tag url
  end
end
