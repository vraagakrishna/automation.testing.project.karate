function () {
    function randomString(length) {
        var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        var result = '';
        for (var i = 0; i < length; i++) {
            result += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return result;
    }

    function randomPassword() {
        return randomString(8) + '1$';
    }

    function randomWeakPassword() {
        return randomString(5);
    }

    function randomDomain() {
        const domains = ['gmail.com', 'yahoo.com', 'outlook.com', 'hotmail.com', 'icloud.com'];
        const randomIndex = Math.floor(Math.random() * domains.length);
        return domains[randomIndex];
    }

    function randomEmail(firstName, lastName) {
        return (
            firstName.toLowerCase().replaceAll(' ', '') + '.' +
            lastName.toLowerCase().replaceAll(' ', '') + '.' +
            Math.floor(Math.random() * 10000) +
            '@' + randomDomain()
        );
    }

    function randomFirstName() {
        return randomString(6);
    }

    function randomLastName() {
        return randomString(8);
    }

    function validUser() {
        var firstName = randomFirstName();
        var lastName = randomLastName();
        var password = randomPassword();

        return {
            firstName: firstName,
            lastName: lastName,
            email: randomEmail(firstName, lastName),
            password: password,
            confirmPassword: password
        };
    }

    function missingFirstName() {
        var u = validUser();
        delete u.firstName;
        return u;
    }

    function missingLastName() {
        var u = validUser();
        delete u.lastName;
        return u;
    }

    function missingEmail() {
        var u = validUser();
        delete u.email;
        return u;
    }

    function missingPassword() {
        var u = validUser();
        delete u.password;
        return u;
    }

    function missingConfirmPassword() {
        var u = validUser();
        delete u.confirmPassword;
        return u;
    }

    function mismatchPasswords() {
        var u = validUser();
        u.confirmPassword = u.firstName;
        return u;
    }

    function weakPassword() {
        var weakPassword = randomWeakPassword();
        var u = validUser();
        u.password = weakPassword;
        u.confirmPassword = weakPassword;
        return u;
    }

    function longFirstName() {
        var u = validUser();
        u.firstName = randomString(500000);
        return u;
    }

    function longLastName() {
        var u = validUser();
        u.lastName = randomString(500000);
        return u;
    }

    function validLoginUser() {
        var u = validUser();
        delete u.firstName;
        delete u.lastName;
        delete u.confirmPassword;

        return u;
    }

    function missingLoginEmail() {
        var u = validLoginUser();
        delete u.email;
        return u;
    }

    function missingLoginPassword() {
        var u = validLoginUser();
        delete u.password;
        return u;
    }

    return {
        validUser: validUser,
        missingFirstName: missingFirstName,
        missingLastName: missingLastName,
        missingEmail: missingEmail,
        missingPassword: missingPassword,
        missingConfirmPassword: missingConfirmPassword,
        mismatchPasswords: mismatchPasswords,
        weakPassword: weakPassword,
        longFirstName: longFirstName,
        longLastName: longLastName,
        missingLoginEmail: missingLoginEmail,
        missingLoginPassword: missingLoginPassword,
        validLoginUser: validLoginUser
    };
}