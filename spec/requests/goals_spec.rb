require 'spec_helper'

describe "Goals" do

  describe "creation" do

    before :each do
      user = Factory :user
      visit signin_path
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button
    end

    describe "failure" do

      it "should not make a new goal" do
        lambda do
          visit new_goal_path
          fill_in "Title", :with => ""
          fill_in "Description", :with => ""
          click_button
          response.should render_template 'goals/new'
          flash[:error] =~ /invalid/i
        end.should_not change(Goal, :count).by 1
      end
    end

    describe "success" do

      it "should make a new goal" do
        lambda do
          visit new_goal_path
          fill_in "Title", :with => "Test this feature"
          fill_in "Description", :with => "Keep on automatically doing it."
          click_button
          response.should render_template 'goals/index'
          flash[:success] =~ /goal created/i
        end.should change(Goal, :count).by 1
      end
    end
  end

  describe "editing" do

    before :each do
      user = Factory :user
      goal = Factory(:goal, :user => user)
      visit signin_path
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button
    end

    describe "failure" do

      it "should not save the goal and report an error" do
        visit dashboard_path
        click_link "Edit"
        fill_in "Description", :with => ""
        click_button
        response.should render_template 'goals/index'
        response.should have_selector('div', :id => "error_explanation")
      end
    end

    describe "success" do
      it "should save the goal" do
        visit dashboard_path
        click_link "Edit"
        fill_in "Description", :with => "EDITED GOAL TEST"
        click_button
        response.should render_template 'goals/index'
        response.should have_selector('td', :content => "EDITED GOAL TEST")
      end
    end
  end
end
