Feature: Register user (reusable)

  Scenario:
    # Expect "user" and "expected" to be passed in
    * assert user != null
    * assert expected != null

    Given url baseUrl + '/auth/register'
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
            id: '#string',
            first_name: '#(user.first_name)',
            last_name: '#(user.last_name)',
            email: '#(user.email)',
            phone: '#(user.phone)',
            role: '#string'
          },
          token: '#string'
        });
        if (!res.pass) karate.fail(res.message);

        // validate JWT
        var jwtUtils = karate.call('classpath:api/common/jwt-utils.js');
        jwtUtils.validateJwtToken(response.data.token, user);
      }
      else {
        if (expected.errors) {
          var res = karate.match(response.errors, expected.errors);
          if (!res.pass) karate.fail(res.message);
        }
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
