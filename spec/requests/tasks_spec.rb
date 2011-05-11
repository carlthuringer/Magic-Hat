require 'spec_helper'

describe "Tasks" do

  before :each do
    user = Factory :user
    visit signin_path
    fill_in "email", :with => user.email
    fill_in "password", :with => user.password
    click_button
    visit new_goal_path
    fill_in "Title", :with => "A sample title"
    fill_in "Description", :with => "Sample description"
    click_button
  end

  describe "create task" do

    describe "failure" do

      it "should reload the page with an error message when description is empty" do
        visit dashboard_path
        click_link "Create a new Task"
        click_button
        response.should have_selector('div#error_explanation')
      end
    end

    describe "success" do

      it "should create the task and show it on the dashboard" do
        expect { 
          visit dashboard_path
          click_link "Create a new Task"
          fill_in "Description", :with => "IT SHOULD CREATE THE TASK"
          click_button
          response.should have_selector('tr>td', :content => "IT SHOULD CREATE THE TASK")
        }.to change(Task, :count).by 1
      end
    end
  end

  describe "edit task" do

    before :each do
      visit dashboard_path
      click_link "Create a new Task"
      fill_in "Description", :with => "IT SHOULD CREATE THE TASK"
      click_button
    end

    describe "failure" do

      it "should reload the page and show an error message" do
        visit dashboard_path
        within ".task_actions" do
          click_link "Edit"
        end
        fill_in "Description", :with => ""
        click_button
        response.should have_selector('div#error_explanation')
      end
    end

    describe "success" do

      it "should edit the task" do
        visit dashboard_path
        within ".task_actions" do
          click_link "Edit"
        end
        fill_in "Description", :with => "IT SHOULD EDIT THE TASK"
        click_button
        response.should have_selector('tr>td', :content => "IT SHOULD EDIT THE TASK")
      end
    end
  end

  describe "Delete Task" do

    before :each do
      visit dashboard_path
      click_link "Create a new Task"
      fill_in "Description", :with => "IT SHOULD CREATE THE TASK"
      click_button
    end

    it "should delete the task" do
      expect {
        visit dashboard_path
        within(".task_actions") { click_link "Delete" }
      }.to change(Task, :count).by -1
    end
  end

  describe "Complete Task" do

    before :each do
      visit dashboard_path
      click_link "Create a new Task"
      fill_in "Description", :with => "IT SHOULD CREATE THE TASK"
      click_button
    end

    # For some reason Webrat can't handle this...
    # it "should result in a successful request" do
      # within(".task_status") { check "ids[]"}
      # click_button "Update Tasks"
      # response.should be_successful
    # end
  end
end
