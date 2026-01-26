Feature: Login user (reusable)

  Scenario:
    # Expect "user" to be passed in
    * assert user != null
    * assert expected != null
    * assert registerUser != null

    Given url baseUrl + '/auth/login'
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
            id: '#(Number(registerUser.id))',
            first_name: '#(registerUser.first_name)',
            last_name: '#(registerUser.last_name)',
            email: '#(registerUser.email)',
            phone: '#(registerUser.phone)',
            role: 'customer',
            last_login: '#? _ == null || _  == "string"'
          },
          token: '#string'
        });
        if (!res.pass) karate.fail(res.message);

        // validate JWT
        var jwtUtils = karate.call('classpath:api/common/jwt-utils.js');
        jwtUtils.validateJwtToken(response.data.token, registerUser);
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
