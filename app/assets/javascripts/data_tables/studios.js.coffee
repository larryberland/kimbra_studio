$ ->
  setUpDataTable(
    $('#studios_table'),
    'aaSorting': [ [ 1, 'asc' ] ]             # sort on name
    'aoColumnDefs': [
      {'bVisible': false, 'aTargets': [ 8 ]} # hide the created_at long format column
      {'iDataSort': 7, 'aTargets': [ 8 ]}   # but use it when you sort on short format column
      {'bVisible': false, 'aTargets': [ 10 ]} # hide the created_at long format column
      {'iDataSort': 9, 'aTargets': [ 10 ]}   # but use it when you sort on short format column
    ]
  )