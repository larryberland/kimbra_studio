$ ->
  setUpDataTable(
    $('#sessions_table'),
    'aaSorting': [ [ 5, 'desc' ] ] # sort on long format created_at desc
    'aoColumnDefs': [
      {'bSortable': false, 'aTargets': [ 1,2 ]}     # do not sort on portrait count, email link
      {'bSearchable': false, 'aTargets': [ 1,2 ]}   # do not search on portrait count, email link
      {'bVisible': false, 'aTargets': [ 4 ]}        # hide the session_at long format column
      {'iDataSort': 3, 'aTargets': [ 4 ]}           # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 4 ]} # declare session_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 6 ]}        # hide the created_at long format column
      {'iDataSort': 5, 'aTargets': [ 6 ]}           # but use it when you sort on short format column
    ]
  )