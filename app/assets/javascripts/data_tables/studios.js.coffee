$ ->
  setUpDataTable(
    $('#studios_table'),
    'aaSorting': [ [ 2, 'asc' ] ]             # sort on name
    'aoColumnDefs': [
      {'bVisible': false, 'aTargets': [ 9 ]} # hide the created_at long format column
      {'iDataSort': 8, 'aTargets': [ 9 ]}   # but use it when you sort on short format column
      {'bVisible': false, 'aTargets': [ 11 ]} # hide the created_at long format column
      {'iDataSort': 10, 'aTargets': [ 11 ]}   # but use it when you sort on short format column
    ]
  )