$ ->
  $('.task-form').hide()
  $('.goal-form').hide()
  # Clicking the gear reveals the form
  $('.task a#form-reveal-button').click ->
    $(this).parents('li').next('.task-form').slideToggle('fast')
    event.preventDefault
  # Clicking the gear reveals the form
  $('.goal a#form-reveal-button').click ->
    $(this).parents('li').next('.goal-form').slideToggle('fast')
    event.preventDefault
