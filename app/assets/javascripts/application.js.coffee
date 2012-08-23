#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require jcrop
#= require spin
#= require spinner
#= require jquery_ui_timepicker_addon
#= require wait
#= require imagesloaded
#= require rails.validations
#= require jquery.orbit-1.2.3.min

$ ->
  $('.flash_notice').each (index, element) ->
      $(element).effect('highlight', 4000).delay(2000).slideUp('slow')
  $('.flash_error').each (index, element) ->
      $(element).effect('highlight', 4000).delay(2000).slideUp('slow')

  $('.datepicker').each (index, element) ->
    $(element).datepicker({ dateFormat: "yy-mm-dd" })

  $('#slides').orbit()

  $('#user_email').focus()