# Build CSS spinner
spinner_opts =
  lines:12, # The number of lines to draw
  length:5, # The length of each line
  width:2, # The line thickness
  radius:5, # The radius of the inner circle
  rotate:0, # The rotation offset
  color:'#eee', # #rgb or #rrggbb
  speed:1, # Rounds per second
  trail:60, # Afterglow percentage
  shadow:false, # Whether to render a shadow
  hwaccel:false, # Whether to use hardware acceleration
  className:'spinner', # The CSS class to assign to the spinner
  zIndex:2e9, # The z-index (defaults to 2000000000)
  top:'auto', # Top position relative to parent in px
  left:'auto' # Left position relative to parent in px

$ ->
  if $('#spinner')
    $('#spinner').append(new Spinner(spinner_opts).spin())

$('#my_submit').click ->
  $('#spinner').toggle()



#$(document).ready(function () {
#    var target = document.getElementById('spinner')
#    if (target) {
#        var spinner = new Spinner(spinner_opts).spin();
#        target.appendChild(spinner.el);
#    }
#});

#$(function () {
#    $("#my_submit").click(function () {
#        $("#spinner").toggle();
#    });
#});