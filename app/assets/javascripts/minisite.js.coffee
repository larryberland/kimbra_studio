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

$ ->
  $('.flash_notice').delay(6000).slideUp('slow')
  $('.flash_error').delay(6000).slideUp('slow')