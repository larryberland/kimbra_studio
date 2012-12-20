$ ->
  setUpDataTable(
    $('#ready_emails_table'),
    'aaSorting': [ [ 3, 'desc' ] ] # sort on long format created_at desc
    'aoColumnDefs': [
      {'bSortable': false, 'aTargets': [ 2 ]}    # do not sort on offer count
      {'bSearchable': false, 'aTargets': [ 2 ]}    # do not search on offer count
      {'bVisible': false, 'aTargets': [ 4 ]} # hide the created_at long format column
      {'iDataSort': 3, 'aTargets': [ 4 ]}   # but use it when you sort on short format column
    ]
  )