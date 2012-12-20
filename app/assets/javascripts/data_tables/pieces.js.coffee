$ ->
  setUpDataTable(
    $('#pieces_table'),
    'aaSorting': [ [ 3, 'asc' ] ] # sort on long format created_at desc
    'aoColumnDefs': [
      {'bSortable': false, 'aTargets': [ 0,4 ]}       # do not sort on Actions, image
      {'bSearchable': false, 'aTargets': [ 0,1,8,9 ]} # do not search on Actions, Parts, Active, Featured
      {'bVisible': false, 'aTargets': [ 11 ]}         # hide the deleted_at long format column
      {'iDataSort': 11, 'aTargets': [ 10 ]}           # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 11 ]}  # declare generated_at to be a date column even though it contains nils
      {'sType': 'currency', 'aTargets': [ 7 ]}        # declare price to be currency for sorting
    ]
  )