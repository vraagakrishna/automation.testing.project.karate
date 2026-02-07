Feature: Get bookings (reusable)

  @ignore
  Scenario:
    # Expect "token" to be passed in
    * assert token != null
    * assert expected != null

    * karate.log('URL: ' + baseUrl + '/bookings')
    * karate.log('HEADER: Authorization ' + 'Bearer ' + token)
    * karate.log('REQUEST: ')
    * karate.log(user)

    Given url baseUrl + '/bookings'
    And header Authorization = 'Bearer ' + token
    When method GET

    * karate.log('RESPONSE TIME: ' + responseTime)
    * karate.log('STATUS CODE: ' + responseStatus)
    * karate.log('RESPONSE: ')
    * karate.log(response)

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
