# Mobile
$('div').live 'pagebeforeshow', (event, ui)->
  $('#statistics').height(70)
  $('#stats-grid-plus-minus a').toggle(->
    $(this).parents('#statistics').animate({ height: "170px"}, 500)
  , ->
    $(this).parents('#statistics').animate({ height: "70px"}, 500)
  )
