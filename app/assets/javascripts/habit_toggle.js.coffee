$ ->
  $('div').live 'pagebeforeshow', (event, ui)->
    $('.habit-fields.hidden').hide()
    $('a.task-toggle-habit').click ->
      my_habit_fields = $(this).parents('.actions').prev('.habit-fields')
      my_habit_fields.slideToggle('fast')
      repeat = $('input[name*="task[schedule_attributes][repeat]"]')
      if repeat.val == '1' then repeat.val("0") else repeat.val("1")
