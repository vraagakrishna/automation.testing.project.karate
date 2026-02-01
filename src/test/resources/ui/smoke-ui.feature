Feature: UI Smoke Tests

  Background:
    * configure driver = driverConfig
    * driver uiUrl

  @ui @smoke
  Scenario: Login page loads
    # Homepage loads and shows company name
    * waitFor('{div}Edendale Sports Projects').exists

    # Navigate to login page
    * click('{button}Login')
    * waitFor('{h2}Sign in to your account')

  @ui @smoke
  Scenario: Register page loads
    # Homepage loads and shows company name
    * waitFor('{div}Edendale Sports Projects').exists

    # Navigate to login page
    * click('{button}Register')
    * waitFor('{h2}Create your account')
