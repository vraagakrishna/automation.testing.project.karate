Feature: Get bookings (reusable)

  Scenario:
    # Expect "token" to be passed in
    * assert token != null
    * assert expected != null

    Given url baseUrl + '/bookings'
    And header Authorization = 'Bearer ' + token
    When method GET

    # common assertions
    * match responseStatus == expected.status
    * match response.success == expected.success
    * match response.message == expected.message

    # return useful info
    * def result =
      """
      {
        status: responseStatus,
        timeMs: responseTime,
        response: response
      }
      """
