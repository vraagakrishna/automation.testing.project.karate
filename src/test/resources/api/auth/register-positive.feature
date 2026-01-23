Feature: User Registration API

  @api2
  Scenario: Register valid users

    * def userFactory = call read('classpath:api/common/user-factory.js')

    * def registerUser =
      """
      function () {
        var user = userFactory.validUser();
        var r = karate.call('classpath:api/auth/register-user.feature', { user: user });

        return {
          user: user,
          status: r.responseStatus,
          timeMs: r.responseTime,
          response: r.response
        };
      }
      """

    * def results = karate.repeat(2, registerUser)

    * match each results[*].status == 201
