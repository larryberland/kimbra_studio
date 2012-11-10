module Jekyll
  class AuthorImageTag < Liquid::Tag

    # Assumes you have a front_matter item in the post called author that looks like: Jim James
    # Creates a simple image tag assuming the picture file is the same name as the author and is a jpg.
    # Usage:  {% author_image %}
    # =>  <img src='/images/jim_james.jpg' alt='Jim James' class='author_image'>
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      post = context.environments.first["page"]
      "<span class='author_image'>" +
          "<img src='/images/#{post['author'].to_s.gsub(' ', '_').downcase}.jpg' alt='#{post['author']}' class='photo_hover2'>" +
          "<br/>" +
          post['author'] +
          "</span>"
    end
  end
end

Liquid::Template.register_tag('author_image', Jekyll::AuthorImageTag)