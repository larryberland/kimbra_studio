# encoding: utf-8

require 'open-uri'

module CarrierWave
  module Uploader
    module Download

      ##
      # Processes the given URL by parsing and escaping it. Public to allow overriding.
      #
      # === Parameters
      #
      # [url (String)] The URL where the remote file is stored
      #
      def process_uri(uri)
        # URI.parse(URI.escape(URI.unescape(uri)))

        puts "USING MY PARSE"
        # https://github.com/jnicklas/carrierwave/issues/700
        URI.parse(uri) # from internet

      end

    end # Download
  end # Uploader
end # CarrierWave
