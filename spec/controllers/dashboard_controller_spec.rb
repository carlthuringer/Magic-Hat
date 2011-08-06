require 'spec_helper'

describe DashboardController do

  describe "GET 'index'" do

    describe "when not signed in" do

      it "should redirect to the signin page" do
        get 'index'
        response.should redirect_to signin_path
      end
    end

    describe "signed in users" do

      it "should assign the instance variables" do

      end

    end

  end
end
