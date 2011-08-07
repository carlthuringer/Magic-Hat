require 'spec_helper'

describe "Tasks" do

  before :each do
    user = Factory :user
    visit signin_path
    fill_in "email", :with => user.email
    fill_in "password", :with => user.password
    click_button
  end

  describe "When a user attempts to create a task" do

    describe "and fails because there is no description" do

      it "they see an error message" do
        visit dashboard_path
        click_button "Add Task"
        response.should have_selector('div.error')
      end
    end

    describe "and succeeds" do

      it "they can see the task added to the dashboard" do
        visit dashboard_path
        fill_in "task_description", :with => "IT SHOULD CREATE THE TASK"
        click_button "Add Task"
        response.should have_selector('a', :content => "IT SHOULD CREATE THE TASK")
      end
    end
  end

  describe "When a user attempt to edit a task description" do

    before :each do
      visit dashboard_path
      fill_in "task_description", :with => "IT SHOULD CREATE THE TASK"
      click_button "Add Task"
    end

    describe "and fails because the description was erased" do

      it "should reload the page and show an error message" do
        within ".tasks" do
          fill_in "task_description", :with => "IT SHOULD CREATE THE TASK"
          click_button "Save"
        end
        response.should have_selector('div.error')
      end
    end

    describe "success" do

      it "should edit the task" do
        # visit dashboard_path
        # within ".task_actions" do
        #   click_link "Edit"
        # end
        # fill_in "Description", :with => "IT SHOULD EDIT THE TASK"
        # click_button
        # response.should have_selector('p', :content => "IT SHOULD EDIT THE TASK")
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

    # it "should delete the task" do
    #   expect {
    #     visit dashboard_path
    #     within(".task_actions") { click_link "Delete" }
    #   }.to change(Task, :count).by -1
    # end
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
