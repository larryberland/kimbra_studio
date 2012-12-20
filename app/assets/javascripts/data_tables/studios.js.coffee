$ ->
  setUpDataTable(
    $('#studios_table'),
    'aaSorting': [ [ 4, 'asc' ] ]             # sort on name
    'aoColumnDefs': [
      {'bVisible': false, 'aTargets': [ 11 ]} # hide the created_at long format column
      {'iDataSort': 10, 'aTargets': [ 11 ]}   # but use it when you sort on short format column
    ]
  )