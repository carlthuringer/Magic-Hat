# Set up defaults. Disable ajax... because it breaks everything all the time.
$(document).bind 'mobileinit', ->
  $.extend $.mobile, ajaxEnabled: false
