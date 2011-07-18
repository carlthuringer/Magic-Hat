$('div').live 'pagecreate', (event, ui)->
  # Statistics toggle
  $('#statistics').height(70)
  uiIcon = $('#stats-grid-plus-minus a').children('span').children('.ui-icon')
  statGridRows = $('#statistics').children('table').children('tbody').children('tr')
  thisWeekRow = $('#statistics').children('table').children('tbody').children('tr.4th-row')
  statGridRows.hide()
  thisWeekRow.show()
  $('#stats-grid-plus-minus a').toggle(->
    statGridRows.show('fast')
    $(this).parents('#statistics').animate({ height: "170px"}, 500)
    uiIcon.removeClass('ui-icon-plus')
    uiIcon.addClass('ui-icon-minus')
  ->
    statGridRows.hide('fast')
    thisWeekRow.show('fast')
    $(this).parents('#statistics').animate({ height: "70px"}, 500)
    uiIcon.removeClass('ui-icon-minus')
    uiIcon.addClass('ui-icon-plus')
  )

  # Form Toggle
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

  # Habit Toggle
  $('.habit-fields.hidden').hide()
  $('input[name*="task[schedule_attributes][repeat]"]').map (i, e) ->
    if e.checked
      $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]').val("1")
    else
      $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]').val("0")

  $('input[name*="task[schedule_attributes][repeat]"]').change ->
    $(this).parents('div').parents('div').next('.habit-fields').slideToggle('fast')
    if $(this).is(":checked")
      $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]').val("1")
    else
      $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]').val("0")
