require 'spec_helper'

describe DashboardController do
  render_views

  describe "GET 'index'" do

    before :each do
      get :index
    end

    it "should be successful" do
      response.should be_successful
    end
  end

end
