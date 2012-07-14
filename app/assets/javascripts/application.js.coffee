#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require jcrop
#= require spin
#= require spinner
#= require jquery_ui_timepicker_addon
#= require wait
#= require imagesloaded

$ ->
  $('.flash_notice').each (index, element) ->
      $(element).effect('highlight', 4000)
  $('.flash_notice').delay(2000).slideUp('slow')
  $('.flash_error').each (index, element) ->
        $(element).effect('highlight', 4000)
  $('.flash_error').delay(2000).slideUp('slow')

$ ->
  $('.datepicker').each (index, element) ->
    $(element).datepicker()