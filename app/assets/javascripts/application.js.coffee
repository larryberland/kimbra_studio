#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require jquery.ui.widget
#= require jquery.ui.rlightbox.min
#= require jcrop
#= require spin
#= require spinner
#= require jquery_ui_timepicker_addon
#= require wait
#= require imagesloaded
#= require rails.validations
#= require jquery.orbit-1.2.3.min
#= require jeditable
#= require ./bootstrap/bootstrap
#= require ./bootstrap/client-side-validation

$ ->
  $('.flash_notice').each (index, element) ->
      $(element).effect('highlight', 6000).delay(2000).slideUp('slow')
  $('.flash_error').each (index, element) ->
      $(element).effect('highlight', 6000).delay(2000).slideUp('slow')

  $('.datepicker').each (index, element) ->
    $(element).datepicker({ dateFormat: "yy-mm-dd" })

  $('#slides').orbit()

  $('#user_email').focus()

  $('.lb_sample').rlightbox();

  clientSideValidations.callbacks.form.fail = (element, message, callback) ->
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
    'bProcessing': true,
  finalOpts = $.extend(defaults, optHash)
  $(tableEl).dataTable(finalOpts)
  $(tableEl).show()

  $.extend $.fn.dataTableExt.oStdClasses,
    'sSortAsc': 'header headerSortDown'
    'sSortDesc': 'header headerSortUp'
    'sSortable': 'header sorting'
    'sWrapper': 'dataTables_wrapper form-inline'