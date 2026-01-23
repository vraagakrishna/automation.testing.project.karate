Feature: Auth Tests

  Background:
    # common setup for all scenarios
    * def userFactory = call read('classpath:api/common/user-factory.js')

  @api
  Scenario Outline: Login fails for invalid input: <name>
    * def variantName = '<variant>'
    * def user = userFactory[variantName]()
    * def expected =
      """
      {
        status: <status>,
        success: false,
        message: <message>,
        error_code: <error_code>
      }
      """

    * karate.log('Running test variant: ', variantName)

    * karate.call('classpath:api/auth/login-user.feature', { user: user, expected: expected })

    Examples:
      | name                                 | variant              | status | message                           | error_code            |
      | Missing Email                        | missingLoginEmail    | 401    | 'Email and password are required' | 'MISSING_CREDENTIALS'  |
      | Missing Password                     | missingLoginPassword | 401    | 'Email and password are required' | 'MISSING_CREDENTIALS' |
      | Valid Data Login Before Registration | validLoginUser       | 401    | 'Invalid email or password'       | 'INVALID_CREDENTIALS' |

  @api
  Scenario Outline: Registration fails for invalid input: <name>
    * def variantName = '<variant>'
    * def user = userFactory[variantName]()
    * def expected =
      """
      {
        status: <status>,
        success: false,
        message: <message>,
        error_code: <error_code>
      }
      """

    * karate.log('Running test variant: ', variantName)

    * karate.call('classpath:api/auth/register-user.feature', { user: user, expected: expected })

    Examples:
      | name                     | variant                | status | message                                       | error_code            |
      | Mising First Name        | missingFirstName       | 400    | 'All fields are required'                     | 'MISSING_FIELDS'      |
      | Missing Last Name        | missingLastName        | 400    | 'All fields are required'                     | 'MISSING_FIELDS'      |
      | Missing Email            | missingEmail           | 400    | 'All fields are required'                     | 'MISSING_FIELDS'      |
      | Missing Password         | missingPassword        | 400    | 'All fields are required'                     | 'MISSING_FIELDS'      |
      | Missing Confirm Password | missingConfirmPassword | 400    | 'All fields are required'                     | 'MISSING_FIELDS'      |
      | Mismatch Password        | mismatchPasswords      | 400    | 'Passwords do not match'                      | 'PASSWORD_MISMATCH'   |
      | Weak Password            | weakPassword           | 400    | 'Password must be at least 6 characters long' | 'WEAK_PASSWORD'       |
      | Long First Name          | longFirstName          | 400    | 'Registration failed. Please try again.'      | 'REGISTRATION_FAILED' |
      | Long Last Name           | longLastName           | 400    | 'Registration failed. Please try again.'      | 'REGISTRATION_FAILED' |

  @api
  Scenario: Register valid users
    * def registerUser =
      """
      function () {
        var user = userFactory.validUser();
        var loginUser = userFactory.toLoginUser(user);

        // 1: Login BEFORE registration -> FAIL
        var loginExpectedFail = {
          status: 401,
          success: false,
          message: 'Invalid email or password',
          error_code: 'INVALID_CREDENTIALS'
        };

        karate.call('classpath:api/auth/login-user.feature', { user: loginUser, expected: loginExpectedFail });

        // 2: Register -> PASS
        var registerExpected = {
          status: 201,
          success: true,
          message: 'User registered successfully'
        };

        karate.call('classpath:api/auth/register-user.feature', { user: user, expected: registerExpected });

        // 3: Re-Register -> FAIL
        var registerExpectedFail = {
          status: 400,
          success: false,
          message: 'User with this email already exists',
          error_code: 'USER_EXISTS'
        }
        karate.call('classpath:api/auth/register-user.feature', { user: user, expected: registerExpectedFail });

        // 4: Login AFTER registration -> PASS
        var loginExpectedPass = {
          status: 200,
          success: true,
          message: 'Login successful'
        };

        karate.call('classpath:api/auth/login-user.feature', { user: loginUser, expected: loginExpectedPass });
      }
      """

    * karate.repeat(2, registerUser)
