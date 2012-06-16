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

$ ->
  $('.flash_notice').each (index, element) ->
    $(element).effect('highlight', 4000)
  $('.flash_notice').delay(4000).slideUp('slow')
  $('.flash_error').delay(4000).slideUp('slow')