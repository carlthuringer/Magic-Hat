
describe "statistics display", ->
  it "should set the initial height of the div to 70px", ->
    loadFixtures("index.html")
    window.setupStatsGrid()
    expect($('#statistics').height()).toEqual(70)
