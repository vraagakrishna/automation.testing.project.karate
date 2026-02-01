Feature: Auth API performance tests

  Background:
    * url baseUrl
    * configure headers = { Content-Type: 'application/json' }

  @api @perf @smoke
  Scenario: Register API performance
    * def user =
      """
      {
        first_name: 'Test',
        last_name: 'User',
        email: 't@g',
        password: 'StringPass123!',
        phone: '123456789'
      }
      """

    * karate.log('URL: ' + baseUrl + '/auth/register')
    * karate.log('REQUEST: ')
    * karate.log(user)

    Given path '/auth/register'
    And request user
    When method POST

    * karate.log('RESPONSE TIME: ' + responseTime)
    * karate.log('STATUS CODE: ' + responseStatus)
    * karate.log('RESPONSE: ')
    * karate.log(response)

    Then status 422

  @api @perf @smoke
  Scenario: Login API performance
    * def user =
      """
      {
        email: 't@g',
        password: 'StringPass123!'
      }
      """

    * karate.log('URL: ' + baseUrl + '/auth/login')
    * karate.log('REQUEST: ')
    * karate.log(user)

    Given path '/auth/login'
    And request user
    When method POST

    * karate.log('RESPONSE TIME: ' + responseTime)
    * karate.log('STATUS CODE: ' + responseStatus)
    * karate.log('RESPONSE: ')
    * karate.log(response)

    Then status 422
