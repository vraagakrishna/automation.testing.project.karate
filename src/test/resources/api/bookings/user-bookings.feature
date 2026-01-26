Feature: User Booking Tests

  Background:
    # common setup for all scenarios
    * def userFactory = call read('classpath:api/common/user-factory.js')
    * def user = userFactory.validUser()
    * def loginUser = userFactory.toLoginUser(user)

    * def registerAndLogin =
      """
      function () {
        // 1: Register --> PASS
        var registerExpected = {
          status: 201,
          success: true,
          message: 'Registration successful'
        };

        karate.log('Register -> PASS')
        var r = karate.call('classpath:api/auth/register-user.feature', { user: user, expected: registerExpected });

        // 2: Login AFTER registration -> PASS
        var loginExpectedPass = {
          status: 200,
          success: true,
          message: 'Login successful'
        };

        var loginResp = karate.call('classpath:api/auth/login-user.feature', {
          user: loginUser,
          expected: loginExpectedPass,
          registerUser: r.response.data.user
        });

        return {
          user: loginResp.response.data.user,
          token: loginResp.response.data.token
        }
      }
      """

    # shared across ALL scenarios in this feature
    * def session = callonce registerAndLogin

  @api
  Scenario Outline: Get Bookings With <name>
    # resolve token dynamically
    * def token =
      """
      function () {
        if ('<tokenType>' === 'NONE') return '';
        if ('<tokenType>' === 'INVALID') return 'this-is-not-a-jwt-' + java.util.UUID.randomUUID();
        if ('<tokenType>' === 'EXPIRED') {
          var jwtUtils = karate.call('classpath:api/common/jwt-utils.js');
          return jwtUtils.expireJwtToken(session.token);
        }
        if ('<tokenType>' === 'VALID') return session.token;
        return '';
      } ()
      """

    * def expected =
      """
      {
        status: <status>,
        success: <success>,
        message: <message>
      }
      """

    * karate.call('classpath:api/bookings/get-bookings.feature', { token: token, expected: expected, registerUser: session.user})

    Examples:
      | name           | tokenType  | status | success | message                          |
      | Without Token  | NONE       | 401    | false   | 'Authorization token required'   |
      | Invalid Token  | INVALID    | 401    | false   | 'Invalid or expired token'       |
      | Expired Token  | EXPIRED    | 401    | false   | 'Invalid or expired token'       |
      | Valid Token    | VALID      | 200    | true    | 'Success' |
