Feature: Auth Tests

  Background:
    # common setup for all scenarios
    * def userFactory = call read('classpath:common/user-factory.js')

  @api
  Scenario Outline: Login fails for invalid input: <name>
    * def variantName = '<variant>'
    * def user = userFactory[variantName]()
    * def expected =
      """
      {
        status: <status>,
        success: false,
        message: <message>
      }
      """

    * karate.log('Running test variant: ', variantName)

    * karate.call('classpath:api/auth/login-user.feature', { user: user, expected: expected, registerUser: {} })

    Examples:
      | name                                 | variant              | status | message                           |
      | Missing Email and Password           | missingPayload       | 400    | 'Email and password are required' |
      | Missing Email                        | missingLoginEmail    | 400    | 'Email and password are required' |
      | Missing Password                     | missingLoginPassword | 400    | 'Email and password are required' |
      | Invalid Email                        | invalidLoginEmail    | 401    | 'Invalid credentials'             |
      | Short Password                       | shortLoginPassword   | 401    | 'Invalid credentials'             |
      | Valid Data Login Before Registration | validLoginUser       | 401    | 'Invalid credentials'             |

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
        errors: <errors>
      }
      """

    * karate.log('Running test variant: ', variantName)

    * karate.call('classpath:api/auth/register-user.feature', { user: user, expected: expected })

    Examples:
      | name              | variant          | status | message             | errors                                                                                                   |
      | Mising First Name | missingFirstName | 422    | 'Validation failed' | {first_name: 'First name is required' }                                                                  |
      | Missing Last Name | missingLastName  | 422    | 'Validation failed' | {last_name: 'Last name is required' }                                                                    |
      | Missing Email     | missingEmail     | 422    | 'Validation failed' | {email: 'Email is required' }                                                                            |
      | Missing Password  | missingPassword  | 422    | 'Validation failed' | {password: 'Password is required' }                                                                      |
      | Missing Phone     | missingPhone     | 422    | 'Validation failed' | {phone: 'Phone number is required' }                                                                     |
      | Short Last Name   | shortLastName    | 422    | 'Validation failed' | {last_namt: 'Last name must be at least 2 characters' }                                                  |
      | Short Password    | shortPassword    | 422    | 'Validation failed' | {password: 'Password must be at least 8 characters' }                                                    |
      | Weak Password     | weakPassword     | 422    | 'Validation failed' | {password: 'Password must contain at least one lowercase letter, one uppercase letter, and one number' } |
      | Short Phone       | shortPhone       | 422    | 'Validation failed' | {phone: 'Phone number must contain at least 10 digits' }                                                 |
      | Long Phone        | longPhone        | 422    | 'Validation failed' | {phone: 'Phone number cannot contain more than 15 digits' }                                              |
      | Long First Name   | longFirstName    | 422    | 'Validation failed' | {first_name: 'First name is too long (maximum 100 characters)'}                                          |
      | Long Last Name    | longLastName     | 422    | 'Validation failed' | {last_name: 'Last name is too long (maximum 100 characters)'}                                            |

  @api
  Scenario: Register + Login flow
    * def flow =
      """
      function () {
        var user = userFactory.validUser();
        var loginUser = userFactory.toLoginUser(user);

        // 1: Login BEFORE registration -> FAIL
        var loginExpectedFail = {
          status: 401,
          success: false,
          message: 'Invalid credentials'
        };

        karate.log('Login BEFORE registration -> FAIL')
        karate.call('classpath:api/auth/login-user.feature', {
          user: loginUser,
          expected: loginExpectedFail,
          registerUser: {}
        });

        // 2: Register -> PASS
        var registerExpected = {
          status: 201,
          success: true,
          message: 'Registration successful'
        };

        karate.log('Register -> PASS')
        var r = karate.call('classpath:api/auth/register-user.feature', { user: user, expected: registerExpected });

        // 3: Re-Register -> FAIL
        var registerExpectedFail = {
          status: 409,
          success: false,
          message: 'Email already registered'
        }

        karate.log('Re-Register -> FAIL')
        karate.call('classpath:api/auth/register-user.feature', { user: user, expected: registerExpectedFail });

        // 4: Login AFTER registration -> PASS
        var loginExpectedPass = {
          status: 200,
          success: true,
          message: 'Login successful'
        };

        karate.log('Login AFTER registration -> PASS')
        karate.call('classpath:api/auth/login-user.feature', {
          user: loginUser,
          expected: loginExpectedPass,
          registerUser: r.response.data.user
        });
      }
      """

    * karate.repeat(2, flow)
