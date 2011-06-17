# Form_toggle
$('div').live 'pagebeforeshow', (event, ui)->
  $('.task-form').hide()
  $('.goal-form').hide()
  # Clicking the gear reveals the form
  $('.task a#form-reveal-button').click (event)->
    event.preventDefault()
    $(this).parents('li').next('.task-form').slideToggle('fast')
  # Clicking the gear reveals the form
  $('.goal a#form-reveal-button').click ->
    event.preventDefault()
    $(this).parents('li').next('.goal-form').slideToggle('fast')
