Feature: SOAP Demo - Integer Calculations

  Background:
    Given url soapUrl
    And header Content-Type = 'text/xml; charset=utf-8'

    * def soapAssert = call read('classpath:soap/common/soap-validators.js')

  @soap
  Scenario Outline: Add integers <a> + <b>
    And header SOAPAction = 'http://tempuri.org/AddInteger'

    * def requestBody = karate.readAsString('classpath:soap/requests/add-integer.xml')
    * eval requestBody = requestBody.replace('${a}', a).replace('${b}', b)
    And request requestBody

    When method POST
    Then status <status>

    * eval
      """
      if (<status> == 200) {
        soapAssert.assertIntegerResult(response, "AddIntegerResult", (<a> + <b>));
      }
      else {
        soapAssert.assertBadRequest(response);
      }
      """

    Examples:
      | a   | b   | status |
      | 2   | 3   | 200    |
      | 10  | 6   | 200    |
      | 0   | 7   | 200    |
      | 0.5 | 0.5 | 400    |
      | -3 | -3   | 200    |

  @soap
  Scenario Outline: Divide integers <a> / <b>
    And header SOAPAction = 'http://tempuri.org/DivideInteger'

    * def requestBody = karate.readAsString('classpath:soap/requests/divide-integer.xml')
    * eval requestBody = requestBody.replace('${a}', a).replace('${b}', b)
    And request requestBody

    When method POST
    Then status <status>

    * eval
      """
      if (<status> == 200) {
        soapAssert.assertIntegerResult(response, "DivideIntegerResult", (<a> / <b>));
      }
      else if(<status> == 400) {
        soapAssert.assertBadRequest(response);
      }
      else {
        soapAssert.assertServerError(response);
      }
      """

    Examples:
      | a   | b   | status |
      | 2   | 3   | 200    |
      | 10  | 6   | 200    |
      | 0   | 7   | 200    |
      | 0.5 | 0.5 | 400    |
      | -3  | -3  | 200    |
      | 1   | 1   | 200    |
      | 0   | 1   | 200    |
      | 1   | 0   | 500    |
