$ ->
  setUpDataTable(
    $('#campaigns_table'),
    'aaSorting': [ [ 0, 'asc' ]]                     # sort on name
    'aoColumnDefs': [
      {'bSearchable': false, 'aTargets': [ 1,2,3,4,5 ]}      # search only name
      {'bSortable': false, 'aTargets': [ 1,2,3,4,5 ]}        # sort only name
    ]
  )