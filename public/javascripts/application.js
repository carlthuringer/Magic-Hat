// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready( function() {
  $('.task-form').hide();
  $('.goal-form').hide();
  // Clicking the gear reveals the form
  $('.task a#form-reveal-button').click( function(event) {
    $(this).parents('li').next('.task-form').slideToggle('fast', function(){});
    event.preventDefault();
  });
  // Clicking the gear reveals the form
  $('.goal a#form-reveal-button').click( function(event) {
    $(this).parents('li').next('.goal-form').slideToggle('fast', function(){});
    event.preventDefault();
  });
});
