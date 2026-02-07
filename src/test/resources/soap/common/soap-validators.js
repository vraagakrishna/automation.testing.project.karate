function () {
    function assertIntegerResult(response, result, expected) {
        var actual = Number(karate.xmlPath(response, '//' + result));
        if (Math.abs(actual - expected) > 1e-12) {
            karate.fail('Expected: ' + expected + ', got: ' + actual);
        }
    }

    function assertBadRequest(response) {
        if (!response.includes('Bad Request')) {
            karate.fail('Expected Bad Request');
        }
    }

    function assertServerError(response) {
        if (!response.includes('Internal server error')) {
            karate.fail('Expected Internal server error');
        }
    }

    return {
        assertIntegerResult,
        assertBadRequest,
        assertServerError
    };
}