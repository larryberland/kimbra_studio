$ ->
  opts =
    'aaSortingFixed': [ [ 0, 'asc' ] ], # sort on sort asc
    'bSort': true
    'sDom': "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    'sPaginationType': 'bootstrap'
    'bProcessing': true
    'aoColumnDefs': [
      {'bVisible': false, 'aTargets': [ 0 ]} # hide sort column
    ]

  window.offersDataTable = $('#offers_table').dataTable(opts).rowReordering(
    sURL:"/admin/customer/emails/#{emailTrack}/offers/update_sort",
    sRequestType: 'POST')
  $('#offers_table').show()

  $.extend $.fn.dataTableExt.oStdClasses,
    'sSortAsc': 'header headerSortDown'
    'sSortDesc': 'header headerSortUp'
    'sSortable': 'header sorting'
    'sWrapper': 'dataTables_wrapper form-inline'