$ ->
  setUpDataTable(
    $('#users_table'),
    'aaSorting': [ [ 2, 'asc' ] ]                    # sort on name
    'aoColumnDefs': [
      {'bSortable': false, 'aTargets': [ 5 ]}        # do not sort on actions
      {'bSearchable': false, 'aTargets': [ 5 ]}      # do not search on actions
      {'bVisible': false, 'aTargets': [ 1 ]}         # hide the sent_at long format column
      {'iDataSort': 1, 'aTargets': [ 0 ]}            # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 1 ]}  # declare generated_at to be a date column even though it contains nils
    ]
  )