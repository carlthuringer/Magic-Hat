
window.formToggleInitialize = ->
  # Initialize by hiding all the forms
  $('.task-form').hide()
  $('.goal-form').hide()
  $('.group-form').hide()
  setupRevealer('.task')
  setupRevealer('.goal')
  setupRevealer('.group')

window.setupRevealer = (targetClass) ->
  $("#{targetClass} a#form-reveal-button").click (event)->
    event.preventDefault()
    thisForm = $(this).parents('li').next("#{targetClass}-form")
    allForms = $(this).parents('ul').children("#{targetClass}-form")
    if !thisForm.is(":visible")
      allForms.hide('fast')
    thisForm.slideToggle('fast')

window.habitToggleInitialize = ->
  # Initialize by hiding the habit fields. This seems pretty crude...
  $('.habit-fields.hidden').hide()
  # Because of something that jQuery Mobile does we have to manually sync the hidden
  # field with the checkbox.
  initialCheckboxSync()
  hideAndShowOnChanges()

window.initialCheckboxSync = ->
  # Iterate over all task schedule repeat elements. The offending checkboxes.
  $('input[name*="task[schedule_attributes][repeat]"]').map (index, element) ->
    myMatchingHiddenField = $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]')

    if element.checked
      myMatchingHiddenField.val("1")
    else
      myMatchingHiddenField.val("0")

window.hideAndShowOnChanges = ->
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

window.habitCheckboxSync = ->
  $('.weekly-days input[type="checkbox"]').map (index, element) ->
    myMatchingHiddenField = $(element).parent('div.ui-checkbox').next('input')

    if element.checked
      myMatchingHiddenField.val("1")
    else
      myMatchingHiddenField.val("0")

    $(element).change ->
      if myMatchingHiddenField.val() == "1"
        myMatchingHiddenField.val("0")
      else
        myMatchingHiddenField.val("1")

$ ->
  console.log(event)
  # Mobiscroll
  # http://code.google.com/p/mobiscroll/
  $('#task_deadline_string').scroller(
    preset: 'datetime',
    dateFormat: 'yy-mm-dd'
  )

  window.statsGrid = 
    uiIcon: $('#stats-grid-plus-minus a').children('span').children('.ui-icon')
    rows: $('#statistics').children('table').children('tbody').children('tr')
    lastRow: $('#statistics').children('table').children('tbody').children('tr.4th-row')
    toggleButton: $('#stats-grid-plus-minus a')
    container: $('#statistics')

    init: ->
      statsGrid.container.height(70)
      # Hide all rows, then show the last one
      statsGrid.rows.hide()
      statsGrid.lastRow.show()
      # Set up the toggler
      statsGrid.bindToggler()

    bindToggler: ->
      statsGrid.toggleButton.toggle( -> 
        statsGrid.show()
      , -> 
        statsGrid.hide() 
      )


    show: ->
      statsGrid.rows.show('fast')
      statsGrid.container.animate({ height: "170px" }, 500)
      statsGrid.uiIcon.removeClass('ui-icon-plus')
      statsGrid.uiIcon.addClass('ui-icon-minus')

    hide: ->
      statsGrid.rows.hide('fast')
      statsGrid.lastRow.show('fast')
      statsGrid.container.animate({ height: "70px" }, 500)
      statsGrid.uiIcon.addClass('ui-icon-plus')
      statsGrid.uiIcon.removeClass('ui-icon-minus')

  # Statistics toggle
  statsGrid.init()

  # Form Toggle
  formToggleInitialize()

  # Habit Toggle
  habitToggleInitialize()

  habitCheckboxSync()
