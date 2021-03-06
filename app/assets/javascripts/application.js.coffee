#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require jquery.ui.widget
#= require jquery.ui.rlightbox
#= require jquery.cookie
#= require jcrop
#= require spin
#= require spinner
#= require jquery_ui_timepicker_addon
#= require wait
#= require imagesloaded
#= require jquery.orbit-1.2.3.min
#= require jeditable
#= require ./bootstrap/bootstrap
#= require rails.validations
#= require ./bootstrap/client-side-validation
#= require bootstrap-tour
#= require clickplus-tour

$ ->
  $('.flash_notice').each (index, element) ->
      $(element).effect('highlight', 6000).delay(2000).slideUp('slow')
  $('.flash_error').each (index, element) ->
      $(element).effect('highlight', 6000).delay(2000).slideUp('slow')

  $('.datepicker').each (index, element) ->
    $(element).datepicker({ dateFormat: "yy-mm-dd" })

  $('#slides').orbit()

  $('#user_email').focus()

  if $('.lb_sample')
    $('.lb_sample').rlightbox()

  if ClientSideValidations?
    ClientSideValidations.callbacks.form.fail = (element, message, callback) ->
      callback()
      $('#spinner').hide()

window.setOlarkUser = ->
  olark('api.chat.updateVisitorNickname',
    snippet: "#{window.currentUserName}, #{window.currentUserStudio}")

window.setUpDataTable = (tableEl, optHash) ->

  defaults =
    'aaSorting': [ [ 0, 'desc' ] ]
    'sDom': "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    'sPaginationType': 'bootstrap'
    'bProcessing': true
    'bStateSave': true
  finalOpts = $.extend(defaults, optHash)
  $(tableEl).dataTable(finalOpts)
  $(tableEl).show()

  $.extend $.fn.dataTableExt.oStdClasses,
    'sSortAsc': 'header headerSortDown'
    'sSortDesc': 'header headerSortUp'
    'sSortable': 'header sorting'
    'sWrapper': 'dataTables_wrapper form-inline'

  $(tableEl).on 'click', 'tr', (event) =>
    console.log $(event.target)
    $(tableEl).children('tbody').children('tr').each (index,element) =>
      $(element).removeClass('selected')
      $(element).children('td').each (index,td) =>
        $(td).removeClass('selected')
    $(event.target).closest('tr').addClass('selected')
    $(event.target).closest('tr').children('td').each (index,td) =>
      $(td).addClass('selected')