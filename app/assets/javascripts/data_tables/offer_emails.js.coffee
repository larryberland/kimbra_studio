$ ->
  setUpDataTable(
    $('#offer_emails_table'),
    'aaSorting': [ [ 3, 'desc' ] ] # sort on long format created_at desc
    'aoColumnDefs': [
      {'bSearchable': false, 'aTargets': [ 3,10 ]}    # do not search on offer count, purchase count
      {'bVisible': false, 'aTargets': [ 4 ]}          # hide the generated_at long format column
      {'iDataSort': 4, 'aTargets': [ 3 ]}             # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 4 ]}   # declare generated_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 6 ]}          # hide the sent_at long format column
      {'iDataSort': 6, 'aTargets': [ 5 ]}             # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 6 ]}   # declare generated_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 8 ]}          # hide the sent_at long format column
      {'iDataSort': 8, 'aTargets': [ 7 ]}             # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 8 ]}   # declare generated_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 11 ]}         # hide the sent_at long format column
      {'iDataSort': 11, 'aTargets': [ 10 ]}           # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 11 ]}  # declare generated_at to be a date column even though it contains nils
    ]
  )