# Build CSS spinner
window.spinnerOpts =
  lines: 12, # The number of lines to draw
  length: 5, # The length of each line
  width: 2, # The line thickness
  radius: 5, # The radius of the inner circle
  rotate: 0, # The rotation offset
  color: '#AAA', # #rgb or #rrggbb
  speed: 1, # Rounds per second
  trail: 60, # Afterglow percentage
  shadow: false, # Whether to render a shadow
  hwaccel: false, # Whether to use hardware acceleration
  className: 'spinner', # The CSS class to assign to the spinner
  zIndex: 2e9, # The z-index (defaults to 2000000000)
  top: 'auto', # Top position relative to parent in px
  left: 'auto'
# Left position relative to parent in px

$ ->
  if $('#spinner')
    # Insert spinner object and append it to the #spinner element.
    spinner = new Spinner(spinnerOpts).spin()
    $('#spinner').append(spinner.el)
    # Add spinner show to #my_submit click event.
    $('#my_submit').click ->
      $('#spinner').toggle()

    $('#my_submit').bind 'invalid', ->
      $('#spinner').toggle()

$ ->
  $('div.spin').each (index, el) ->
    # Insert spinner object and append it to the corresponding #spinner_xx element.
    span = $(el).find('.spinner')
    input_or_button_or_anchor = $(span).prev()
    spinner = new Spinner(spinnerOpts).spin()
    $(span).append(spinner.el)
    # Add spinner show to #my_submit click event.
    $(input_or_button_or_anchor).click ->
      $(span).toggle()
    $(input_or_button_or_anchor).bind 'invalid', ->
      $(span).toggle()