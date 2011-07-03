# Mobile
$('div').live 'pagebeforeshow', (event, ui)->
  $('#statistics').height(70)
  uiIcon = $('#stats-grid-plus-minus a').children('span').children('.ui-icon')
  $('#stats-grid-plus-minus a').toggle(->
    $(this).parents('#statistics').animate({ height: "170px"}, 500)
    uiIcon.removeClass('ui-icon-plus')
    uiIcon.addClass('ui-icon-minus')
  ->
    $(this).parents('#statistics').animate({ height: "70px"}, 500)
    uiIcon.removeClass('ui-icon-minus')
    uiIcon.addClass('ui-icon-plus')
  )
