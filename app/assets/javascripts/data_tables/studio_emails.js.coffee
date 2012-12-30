$ ->
  setUpDataTable(
    $('#studio_emails_table'),
    'aaSorting': [ [ 4, 'desc' ] ]                   # sort on click throughs
    'aoColumnDefs': [
      {'bSearchable': false, 'aTargets': [ 2,3,4,5,6 ]}   # do not search on dates or actions
      {'bSortable': false, 'aTargets': [ 6 ]}        # do not sort on actions
      {'bVisible': false, 'aTargets': [ 3 ]}         # hide the generated_at long format column
      {'iDataSort': 3, 'aTargets': [ 2 ]}            # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 3 ]}  # declare generated_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 5 ]}         # hide the sent_at long format column
      {'iDataSort': 5, 'aTargets': [ 4 ]}            # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 5 ]}  # declare generated_at to be a date column even though it contains nils
    ]
  )