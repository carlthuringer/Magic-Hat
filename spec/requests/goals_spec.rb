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
      visit signin_path
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button
    end

    describe "failure" do

      before :each do
        click_link
      end
    end
  end
end
