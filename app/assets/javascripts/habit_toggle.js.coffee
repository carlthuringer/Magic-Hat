$ ->
  $('div').live 'pagebeforeshow', (event, ui)->
    $('.habit-fields.hidden').hide()
    $('input[name*="task[schedule_attributes][repeat]"]').map (i, e) ->
      if e.checked
        $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]').val("1")
      else
        $(this).parent('div.ui-checkbox').next('input[name*= task[schedule_attributes][repeat] ]').val("0")

    $('input[name*="task[schedule_attributes][repeat]"]').change ->
      $(this).parents('div').parents('div').next('.habit-fields').slideToggle('fast')
      if $(this).is(":checked")
        $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]').val("1")
      else
        $(this).parent('div.ui-checkbox').next('input[name*="task[schedule_attributes][repeat]"]').val("0")
