Feature: Auth UI validation

  Background:
    * configure driver = driverConfig
    * driver uiUrl
    * def start = new Date().getTime()

    * def userFactory = call read('classpath:common/user-factory.js')

  @ui @perf
  Scenario Outline: Login validation - <name>
    # Homepage loads and shows company name
    * waitFor('{div}Edendale Sports Projects').exists
    * def loadTime = new Date().getTime() - start

    * karate.log('Home Page load time (ms):', loadTime)

    * assert loadTime < 3500

    # Navigate to login page
    * click('{button}Login')
    * waitFor('{h2}Sign in to your account')

    * def data = userFactory[variant]()

    * karate.log('DATA: ')
    * karate.log(data)

    * if (data.email != null) below('{}Email Address').input(data.email)
    * if (data.password != null) below('{}Password').input(data.password)

    * def start = new Date().getTime()
    * click('{button}Sign in')

    * waitFor(error)

    * def submitTime = new Date().getTime() - start

    * karate.log('Login submit time (ms):', submitTime)

    * assert submitTime < 3500

    Examples:
      | name              | variant              | error                                    |
      | Blank Login       | missingPayload       | {}Email is required                      |
      | Blank Login       | missingPayload       | {}Password is required                   |
      | Email only        | missingLoginPassword | {}Password is required                   |
      | Password only     | missingLoginEmail    | {}Email is required                      |
      | Invalid Email     | invalidLoginEmail    | {}Invalid email address                  |
      | Short Password    | shortLoginPassword   | {}Password must be at least 6 characters |
      | Valid Credentials | validLoginUser       | {}Invalid credentials                    |

  @ui @perf
  Scenario Outline: Register validation - <name>
    # Homepage loads and shows company name
    * waitFor('{div}Edendale Sports Projects').exists
    * def loadTime = new Date().getTime() - start

    * karate.log('Home Page load time (ms):', loadTime)

    * assert loadTime < 3500

    # Navigate to login page
    * click('{button}Register')
    * waitFor('{h2}Create your account')

    * def data = userFactory[variant]()

    # UI tests should not have '+27'; the application adds it in before sending to BE
    * if (data.phone != null) data.phone = data.phone.substring(3)

    * karate.log('DATA: ')
    * karate.log(data)

    * if (data.first_name != null) below('{}First Name').input(data.first_name)
    * if (data.last_name != null) below('{}Last Name').input(data.last_name)
    * if (data.email != null) below('{}Email Address').input(data.email)
    * if (data.phone != null) below('{}Phone Number *').input(data.phone)
    * if (data.password != null) below('{}Password').input(data.password)
    * if (data.confirm_password != null) below('{}Confirm Password').input(data.confirm_password)

    * if (agree_terms == 'true') leftOf('{}I agree to the').click()

    * click('{button}Create Account')

    * if (agree_terms == 'true') waitFor(error)

    # only validate browser popup when checkbox is NOT ticked
    * eval
      """
      if (agree_terms != 'true')
      {
        // Add a small wait for the validationMessage animation to occur
        java.lang.Thread.sleep(150);
        var msg = script("document.querySelector('#agree-terms').validationMessage");
      
        var res = karate.match(msg, error);
        if (!res.pass) karate.fail(res.message);
      }
      """

    Examples:
      | name                     | variant                | agree_terms | error                                                                                                  |
      | Blank                    | missingPayload         | false       | Please tick this box if you want to proceed.                                                           |
      | Mising First Name        | missingFirstName       | true        | {}First name is required                                                                               |
      | Mising Last Name         | missingLastName        | true        | {}Last name is required                                                                                |
      | Missing Email            | missingEmail           | true        | {}Email is required                                                                                    |
      | Missing Phone            | missingPhone           | true        | {}Phone number is required                                                                             |
      | Missing Password         | missingPassword        | true        | {}Password is required                                                                                 |
      | Missing Confirm Password | missingConfirmPassword | true        | {}Please confirm your password                                                                         |
      | Short Last Name          | shortLastName          | true        | {}Last name must be at least 2 characters                                                              |
      | Short Password           | shortPassword          | true        | {}Password must be at least 8 characters                                                               |
      | Weak Password            | weakPassword           | true        | {}Password must contain at least one uppercase letter, lowercase letter, number, and special character |
      | Mismatch Passwords       | mismatchPasswords      | true        | {}Passwords do not match                                                                               |
      | Short Phone              | shortPhone             | true        | {}Please enter a valid 9-digit phone number (e.g., 828167854 or 0828167854)                            |
      | Long Phone               | longPhone              | true        | {}Please enter a valid 9-digit phone number (e.g., 828167854 or 0828167854)                            |
      | Long First Name          | longFirstName          | true        | First name is too long (maximum 100 characters)                                                        |
      | Long Last Name           | longLastName           | true        | Last name is too long (maximum 100 characters)                                                         |
