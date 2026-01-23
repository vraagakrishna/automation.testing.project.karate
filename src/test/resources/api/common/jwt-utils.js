function () {
    function decodeJwt(token) {
        // split into 3 parts
        var parts = token.split('.');
        if (parts.length !== 3) {
            throw 'Invalid JWT token: ' + token;
        }

        // decode payload (Base64URL)
        var payload = parts[1];

        // Base64URL to Base64
        payload = payload.replace(/-/g, '+').replace(/_/g, '/');

        // decode
        var jsonPayload = new java.lang.String(java.util.Base64.getDecoder().decode(payload), 'UTF-8');
        return JSON.parse(jsonPayload);
    }

    function validateJwtToken(jwtToken, expectedUser) {
        var decoded = decodeJwt(jwtToken);

        if (decoded.userId != expectedUser.id) {
            karate.fail('JWT userId does not match: ' + decoded.userId + ' != ' + expectedUser.id);
        }

        if (decoded.email != expectedUser.email) {
            karate.fail('JWT email does not match: ' + decoded.email + ' != ' + expectedUser.email);
        }

        return true;
    }

    return {
        decodeJwt: decodeJwt,
        validateJwtToken: validateJwtToken
    };
}
