Feature: Login user (reusable)

  Scenario:
    # Expect "user" to be passed in
    * assert user != null
    * assert expected != null
    * assert registerUser != null

    Given url baseUrl + '/login'
    And request user
    When method POST

    # common assertions
    * match responseStatus == expected.status
    * match response.success == expected.success
    * match response.message == expected.message

    # conditional validation
    * eval
      """
      if (expected.success) {
        var res = karate.match(response.data, {
          user: {
            id: '#(registerUser.id)',
            firstName: '#(registerUser.firstName)',
            lastName: '#(registerUser.lastName)',
            email: '#(registerUser.email)',
            role: 'user',
            createdAt: '#string',
            updatedAt: '#string'
          },
          token: '#string'
        });
        if (!res.pass) karate.fail(res.message);

        // validate JWT
        var jwtUtils = karate.call('classpath:api/common/jwt-utils.js');
        jwtUtils.validateJwtToken(response.data.token, registerUser);
      }
      else {
        var res = karate.match(response.error_code, expected.error_code);
        if (!res.pass) karate.fail(res.message);
      }
      """

    # return useful info
    * def result =
      """
      {
        status: responseStatus,
        timeMs: responseTime,
        response: response
      }
      """
