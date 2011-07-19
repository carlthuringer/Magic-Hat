$('div').live 'pagecreate', (event, ui)->
  # Mobiscroll
  # http://code.google.com/p/mobiscroll/
  $('#task_deadline_string').scroller(
    preset: 'datetime',
    dateFormat: 'yy-mm-dd'
  )

  # Statistics toggle
  # Set the initial height of the #statistics div
  $('#statistics').height(70)
  # Save up some useful jQuery objects
  uiIcon = $('#stats-grid-plus-minus a').children('span').children('.ui-icon')
  statGridRows = $('#statistics').children('table').children('tbody').children('tr')
  thisWeekRow = $('#statistics').children('table').children('tbody').children('tr.4th-row')
  # Initially hide the statgrid rows, then show only the current week.
  statGridRows.hide()
  thisWeekRow.show()
  # Toggle the display. First click shows all rows by resizing the container. 
  # It also tweaks some classes so that the icon changes from plus to minus
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
  # Initialize by hiding all the forms
  $('.task-form').hide()
  $('.goal-form').hide()
  # Clicking the gear reveals the task form
  # If you clicked the gear for this form and it's already showing, hide it.
  # At any rate hide all other forms.
  $('.task a#form-reveal-button').click (event)->
    event.preventDefault()
    if !$(this).parents('li').next('.task-form').is(":visible")
      $(this).parents('ul').children('.task-form').hide('fast')
    $(this).parents('li').next('.task-form').slideToggle('fast')
  # Clicking the gear reveals the goal form
  # If you clicked the gear for this form and it's already showing, hide it.
  # At any rate hide all other forms.
  $('.goal a#form-reveal-button').click ->
    event.preventDefault()
    if !$(this).parents('li').next('.goal-form').is(":visible")
      $(this).parents('ul').children('.goal-form').hide('fast')
    $(this).parents('li').next('.goal-form').slideToggle('fast')

  # Habit Toggle
  # Initialize by hiding the habit fields. This seems pretty crude...
  $('.habit-fields.hidden').hide()
  # Because of something that jQuery Mobile does we have to manually sync the hidden
  # field with the checkbox.
  $('input[name*="task[schedule_attributes][repeat]"]').map (i, e) ->
    if e.checked
      $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]').val("1")
    else
      $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]').val("0")

  # Finally, if the repeat checkbox changes, toggle the form from hidden to showing.
  # Also sync the value of the hidden checkbox.
  $('input[name*="task[schedule_attributes][repeat]"]').change ->
    $(this).parents('div').parents('div').next('.habit-fields').slideToggle('fast')
    if $(this).is(":checked")
      $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]').val("1")
    else
      $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]').val("0")
