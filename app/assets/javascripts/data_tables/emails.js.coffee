$ ->
  setUpDataTable(
    $('#emails_table'),
    'aaSorting': [ [ 6, 'desc' ] ] # sort on long format created_at desc
    'aoColumnDefs': [
      {'bSortable': false, 'aTargets': [ 0,1,2,3 ]}   # do not sort on Actions
      {'bSearchable': false, 'aTargets': [ 0,1,2,3 ]} # do not search on Actions
      {'bVisible': false, 'aTargets': [ 7 ]}          # hide the generated_at long format column
      {'iDataSort': 7, 'aTargets': [ 6 ]}             # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 7 ]}   # declare generated_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 9 ]}          # hide the sent_at long format column
      {'iDataSort': 9, 'aTargets': [ 8 ]}             # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 9 ]}   # declare generated_at to be a date column even though it contains nils
    ]
  )