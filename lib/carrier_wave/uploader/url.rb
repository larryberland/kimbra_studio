# encoding: utf-8

module CarrierWave
  module Uploader
    module Url
      extend ActiveSupport::Concern
      include CarrierWave::Uploader::Configuration

      ##
      # === Parameters
      #
      # [Hash] optional, the query params (only AWS)
      #
      # === Returns
      #
      # [String] the location where this file is accessible via a url
      #
      def url(options = {})
        if file.respond_to?(:url) and not file.url.blank?
          # this should be a remote url where the file is ex Amazon S3
          #puts "USING MY URL arity=>#{file.method(:url).arity}"
          # LDB for some reason the options is coming in as nil
          #     when it is nil then the carrierwave file.url method bombs..
          options ||= {}
          file.method(:url).arity == 0 ? file.url : file.url(options)
        elsif current_path
          # this should be a local path on the server
          (base_path || "") + File.expand_path(current_path).gsub(File.expand_path(root), '')
        end
      end

    end # Url
  end # Uploader
end # CarrierWave
