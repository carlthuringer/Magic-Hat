Feature: Users
  In order to become a member of the site and use other features
  people that want to manage plans and tasks
  want to register an account, log in and log out.
  
  Scenario: Find the registration page
    Given I am on the home page
    When I click the Sign Up link
    Then I should see the registration page.

  Scenario: Register new user
    Given I am on the new user registration page
    When I fill in my account information
    And I click the registration button
    Then I should see my user name
    And I should see my email

  Scenario: Delete user account
    Given I am signed in and on my account settings page
    When I click the account deletion button
    And I confirm my choice
    Then I should see the home page
    And I should see a message confirming my account has been deleted
