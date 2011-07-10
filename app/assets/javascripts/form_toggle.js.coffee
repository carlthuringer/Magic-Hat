# Form_toggle
$('div').live 'pagebeforeshow', (event, ui)->
  $('.task-form').hide()
  $('.goal-form').hide()
  # Clicking the gear reveals the form
  $('.task a#form-reveal-button').click (event)->
    event.preventDefault()
    if !$(this).parents('li').next('.task-form').is(":visible")
      $(this).parents('ul').children('.task-form').hide('fast')
    $(this).parents('li').next('.task-form').slideToggle('fast')
  # Clicking the gear reveals the form
  $('.goal a#form-reveal-button').click ->
    event.preventDefault()
    if !$(this).parents('li').next('.goal-form').is(":visible")
      $(this).parents('ul').children('.goal-form').hide('fast')
    $(this).parents('li').next('.goal-form').slideToggle('fast')
