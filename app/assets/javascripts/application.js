// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jcrop
//= require_tree .

// Build CSS spinner  =============================
var spinner_opts = {
    lines:12, // The number of lines to draw
    length:5, // The length of each line
    width:2, // The line thickness
    radius:5, // The radius of the inner circle
    rotate:0, // The rotation offset
    color:'#eee', // #rgb or #rrggbb
    speed:1, // Rounds per second
    trail:60, // Afterglow percentage
    shadow:false, // Whether to render a shadow
    hwaccel:false, // Whether to use hardware acceleration
    className:'spinner', // The CSS class to assign to the spinner
    zIndex:2e9, // The z-index (defaults to 2000000000)
    top:'auto', // Top position relative to parent in px
    left:'auto' // Left position relative to parent in px
};

$(document).ready(function () {
    var target = document.getElementById('spinner')
    if (target) {
        var spinner = new Spinner(spinner_opts).spin();
        target.appendChild(spinner.el);
    }
});

$(function () {
    $("#my_submit").click(function () {
        $("#spinner").toggle();
    });
});

// ================================================

jQuery(window).ready(
    function () {
        jQuery('.flash_notice').delay(6000).slideUp('slow');
        jQuery('.flash_error').delay(6000).slideUp('slow');
    }
);