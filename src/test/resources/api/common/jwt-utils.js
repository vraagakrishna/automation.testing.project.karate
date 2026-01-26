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

        if (expectedUser.id != null && decoded.user_id != expectedUser.id) {
            karate.fail('JWT userId does not match: ' + decoded.userId + ' != ' + expectedUser.id);
        }

        if (decoded.email != expectedUser.email) {
            karate.fail('JWT email does not match: ' + decoded.email + ' != ' + expectedUser.email);
        }

        return true;
    }

    function expireJwtToken(validToken) {
        var payload = decodeJwt(validToken);
        var parts = validToken.split('.');

        // set exp to 1 hour ago
        payload.exp = Math.floor(Date.now() / 1000) - 3600;

        var modifiedPayload = java.util.Base64
                                        .getUrlEncoder()
                                        .withoutPadding()
                                        .encodeToString(
                                            new java.lang.String(JSON.stringify(payload)).getBytes('UTF-8')
                                        );

        // intentionally keep signature invalid
        return parts[0] + '.' + modifiedPayload + '.' + parts[2];
    }

    return {
        decodeJwt: decodeJwt,
        validateJwtToken: validateJwtToken,
        expireJwtToken: expireJwtToken
    };
}
