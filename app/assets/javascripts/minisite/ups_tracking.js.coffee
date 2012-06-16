$ ->
  $('#shopping_shipping_tracking').keydown ->
    setTimeout ->
      examine()
    , 50

examine = ->
  message = ''
  # clean up any unwanted chars.
  tracking = $('#shopping_shipping_tracking').val().replace(/[^\w^\d]/g,'').toUpperCase()
  if tracking.substr(0,2) == '1Z'
    message += 'UPS tracking number. '
  if tracking.substr(2,6).length == 6
    switch tracking.substr(2,6)
      when 'A5147X'
        message += 'Using Kimbra\'s UPS number. '
      else
        message += 'NOT Kimbra\'s UPS number. '
  if tracking.substr(8,2).length == 2
    switch tracking.substr(8,2)
      when '01'
        message += 'USA Next Day Air'
      when '02'
        message += 'USA 2nd Day Air'
      when '03'
        message += 'USA Ground shipping.'
      when '11'
        message += 'USA Standard shipping.'
      when '12'
        message += 'USA 3 Day Select.'
      when '59'
        message += 'USA 2nd Day Air AM.'
      when '13'
        message += 'USA Next Day Air Saver.'
      else
        message += 'Not sure what delivery serivce level. '
  if tracking.length == 18
    message += ' Correct length.'
  $('#feedback').text(message)