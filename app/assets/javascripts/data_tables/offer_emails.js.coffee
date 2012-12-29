$ ->
  setUpDataTable(
    $('#offer_emails_table'),
    'aaSorting': [ [ 2, 'desc' ] ] # sort on long format created_at desc
    'aoColumnDefs': [
      {'bSearchable': false, 'aTargets': [ 2,9 ]}    # do not search on offer count, purchase count
      {'bVisible': false, 'aTargets': [ 3 ]}          # hide the generated_at long format column
      {'iDataSort': 3, 'aTargets': [ 2 ]}             # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 3 ]}   # declare generated_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 5 ]}          # hide the sent_at long format column
      {'iDataSort': 5, 'aTargets': [ 4 ]}             # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 5 ]}   # declare generated_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 7 ]}          # hide the sent_at long format column
      {'iDataSort': 7, 'aTargets': [ 6 ]}             # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 7 ]}   # declare generated_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 10 ]}         # hide the sent_at long format column
      {'iDataSort': 10, 'aTargets': [ 9 ]}           # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 10 ]}  # declare generated_at to be a date column even though it contains nils
    ]
  )