# Save up some useful jQuery objects
uiIcon = $('#stats-grid-plus-minus a').children('span').children('.ui-icon')
statGridRows = $('#statistics').children('table').children('tbody').children('tr')
thisWeekRow = $('#statistics').children('table').children('tbody').children('tr.4th-row')
statsGrid = $('#stats-grid-plus-minus a')

showStatsGrid = (statsGrid) ->
  statGridRows.show('fast')
  $(this).parents('#statistics').animate({ height: "170px"}, 500)
  uiIcon.removeClass('ui-icon-plus')
  uiIcon.addClass('ui-icon-minus')

hideStatsGrid = (statsGrid) ->
  statGridRows.hide('fast')
  thisWeekRow.show('fast')
  $(this).parents('#statistics').animate({ height: "70px"}, 500)
  uiIcon.removeClass('ui-icon-minus')
  uiIcon.addClass('ui-icon-plus')

showHideStatsGrid = (statsGrid) ->
  statsGrid.toggle( showStatsGrid(), hideStatsGrid() )

window.setupStatsGrid = ->
  # Initial height of stats grid container
  $('#statistics').height(70)
  # Hide all rows, then show the last one
  statGridRows.hide()
  thisWeekRow.show()
  # Set up the toggler
  showHideStatsGrid(statsGrid)

formToggleInitialize = ->
  # Initialize by hiding all the forms
  $('.task-form').hide()
  $('.goal-form').hide()
  $('.group-form').hide()
  setupRevealer('.task')
  setupRevealer('.goal')
  setupRevealer('.group')

setupRevealer = (targetClass) ->
  $("#{targetClass} a#form-reveal-button").click (event)->
    event.preventDefault()
    thisForm = $(this).parents('li').next("#{targetClass}-form")
    allForms = $(this).parents('ul').children("#{targetClass}-form")
    if !thisForm.is(":visible")
      allForms.hide('fast')
    thisForm.slideToggle('fast')

habitToggleInitialize = ->
  # Initialize by hiding the habit fields. This seems pretty crude...
  $('.habit-fields.hidden').hide()
  # Because of something that jQuery Mobile does we have to manually sync the hidden
  # field with the checkbox.
  initialCheckboxSync()

initialCheckboxSync = ->
  # Iterate over all task schedule repeat elements. The offending checkboxes.
  $('input[name*="task[schedule_attributes][repeat]"]').map (index, element) ->
    myMatchingHiddenField = $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]')

    if element.checked
      myMatchingHiddenField.val("1")
    else
      myMatchingHiddenField.val("0")

hideAndShowOnChanges = ->
  # Finally, if the repeat checkbox changes, toggle the form from hidden to showing.
  # Also sync the value of the hidden checkbox.
  $('input[name*="task[schedule_attributes][repeat]"]').change ->
    myContainer = $(this).parents('div').parents('div').next('.habit-fields')
    myMatchingHiddenField = $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]')

    myContainer.slideToggle('fast')
    if $(this).is(":checked")
      myMatchingHiddenField.val("1")
    else
      myMatchingHiddenField.val("0")

$('div').live 'pagecreate', (event, ui)->
  # Mobiscroll
  # http://code.google.com/p/mobiscroll/
  $('#task_deadline_string').scroller(
    preset: 'datetime',
    dateFormat: 'yy-mm-dd'
  )

  # Statistics toggle
  setupStatsGrid(statsGrid)

  # Form Toggle
  formToggleInitialize()

  # Habit Toggle
  habitToggleInitialize()
