require 'spec_helper'

describe HabitsController do

  describe "GET index" do

    it "has all of a user's Habits" do
      pending "Need to set up the relationship between users and habits."
      get index

      response.should have_selector(".habit", :count => 2)
    end

  end

end
