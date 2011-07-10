# Mobile
$('div').live 'pagebeforeshow', (event, ui)->
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
