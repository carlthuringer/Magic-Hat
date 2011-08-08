require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do

    describe "when not signed in" do

      it "should be successful" do
        get 'home'
        response.should be_success
      end
    end

    describe "when signed in" do

      it "should redirect to the dashboard" do
        controller.stub(:signed_in?).and_return(true)
        get 'home'
        response.should redirect_to dashboard_path
      end
    end
  end
end
