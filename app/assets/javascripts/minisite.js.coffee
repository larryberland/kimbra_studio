#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require jcrop
#= require spin
#= require spinner
#= require jquery_ui_timepicker_addon
#= require minisite/portraits
#= require wait
#= require imagesloaded
#= require shopping/purchases
#= require minisite/ups_tracking
#= require ./bootstrap/bootstrap
#= require rails.validations

$ ->
  $('.flash_notice').each (index, element) ->
      $(element).effect('highlight', 4000).delay(4000).slideUp('slow')
  $('.flash_error').each (index, element) ->
      $(element).effect('highlight', 4000).delay(4000).slideUp('slow')
  $('#error_explanation').effect('highlight', 4000)
  # Set body padding on page load and page resize.
# turning off fixed navbar
#  bodyPaddingTop = $('#navbar').css('height')
#  $('body').css('padding-top', bodyPaddingTop)
#  $(window).resize ->
#    $('body').css('padding-top', bodyPaddingTop)
