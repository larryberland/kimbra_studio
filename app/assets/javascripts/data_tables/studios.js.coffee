$ ->
  setUpDataTable(
    $('#studios_table'),
    'aaSorting': [ [ 11, 'asc' ] ] # sort on long format created_at desc
    'aoColumnDefs': [
      {'bVisible': false, 'aTargets': [ 12 ]} # hide the created_at long format column
      {'iDataSort': 11, 'aTargets': [ 12 ]}   # but use it when you sort on short format column
    ]
  )