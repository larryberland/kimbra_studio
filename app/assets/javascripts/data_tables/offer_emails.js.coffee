$ ->
  setUpDataTable(
    $('#offer_emails_table'),
    'aaSorting': [ [ window.sentColumn, 'desc' ] ] # sort on long format created_at desc
    'aoColumnDefs': [
      {'bSearchable': false, 'aTargets': [ 3,10 ]}    # do not search on offer count, purchase count
      {'bVisible': false, 'aTargets': [ 5 ]}          # hide the generated_at long format column
      {'iDataSort': 5, 'aTargets': [ 4 ]}             # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 5 ]}   # declare generated_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 7 ]}          # hide the sent_at long format column
      {'iDataSort': 7, 'aTargets': [ 6 ]}             # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 7 ]}   # declare generated_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 9 ]}          # hide the sent_at long format column
      {'iDataSort': 9, 'aTargets': [ 8 ]}             # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 9 ]}   # declare generated_at to be a date column even though it contains nils
      {'bVisible': false, 'aTargets': [ 12 ]}         # hide the sent_at long format column
      {'iDataSort': 12, 'aTargets': [ 11 ]}           # but use it when you sort on short format column
      {'sType': 'dateswithnils', 'aTargets': [ 12 ]}  # declare generated_at to be a date column even though it contains nils
    ]
  )