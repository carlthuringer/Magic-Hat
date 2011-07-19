describe "statistics display", ->
  it "should set the initial height of the div to 70px", ->
    expect($('#statistics').height()).toEqual(70)
