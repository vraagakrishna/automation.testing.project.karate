Feature: Register user (reusable)

  Scenario:
    # Expect "user" and "expected" to be passed in
    * assert user != null
    * assert expected != null

    Given url baseUrl + '/register'
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
      karate.match(response.data, {
        id: '#string',
        firstName: '#(user.firstName)',
        lastName: '#(user.lastName)',
        email: '#(user.email)',
        createdAt: '#string'
      });
    } else {
      karate.match(response.error_code, expected.error_code);
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
