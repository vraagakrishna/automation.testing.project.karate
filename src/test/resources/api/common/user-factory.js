function () {
    function randomString(length) {
        var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        var result = '';
        for (var i = 0; i < length; i++) {
            result += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return result;
    }

    function randomPhone(digits) {
        if (!digits || digits <= 0)
            throw 'digits must be a positive number';

        var phone = '';
        for (var i = 0; i < digits; i++) {
            phone += Math.floor(Math.random() * 10);
        }
        return phone;
    }

    function randomPassword(minLength) {
        minLength = minLength || 8;

        var lowercase = 'abcdefghijklmnopqrstuvwxyz';
        var uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        var numbers   = '0123456789';
        var allChars  = lowercase + uppercase + numbers;

        // 1: guarantee required characters
        var passwordChars = [
            lowercase.charAt(Math.floor(Math.random() * lowercase.length)),
            uppercase.charAt(Math.floor(Math.random() * uppercase.length)),
            numbers.charAt(Math.floor(Math.random() * numbers.length))
        ];

        // 2: fill remaining length
        while (passwordChars.length < minLength) {
            passwordChars.push(
                allChars.charAt(Math.floor(Math.random() * allChars.length))
            );
        }

        // 3: shuffle to avoid predictable order
        for (var i = passwordChars.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var temp = passwordChars[i];
            passwordChars[i] = passwordChars[j];
            passwordChars[j] = temp;
        }

        return passwordChars.join('');
    }

    function randomShortPassword() {
        return randomString(5);
    }

    function randomWeakPassword(minLength) {
        minLength = minLength || 8;

        var lowercase = 'abcdefghijklmnopqrstuvwxyz';
        var uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        var numbers   = '0123456789';

        var pools = [
            lowercase,
            uppercase,
            numbers,
            lowercase + uppercase,
            lowercase + numbers,
            uppercase + numbers
        ];

        // pick a pool that is missing at least one required category
        var chosenPool = pools[Math.floor(Math.random() * pools.length)];

        var password = '';
        for (var i = 0; i < minLength; i++) {
            password += chosenPool.charAt(
                Math.floor(Math.random() * chosenPool.length)
            );
        }

        return password;
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
        var password = randomPassword(8);

        return {
            first_name: firstName,
            last_name: lastName,
            email: randomEmail(firstName, lastName),
            password: password,
            phone: randomPhone(10)
        };
    }

    function missingFirstName() {
        var u = validUser();
        delete u.first_name;
        return u;
    }

    function missingLastName() {
        var u = validUser();
        delete u.last_name;
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

    function missingPhone() {
        var u = validUser();
        delete u.phone;
        return u;
    }

    function shortLastName() {
        var u = validUser();
        u.last_name = randomString(1);
        return u;
    }

    function shortPassword() {
        var weakPassword = randomShortPassword();
        var u = validUser();
        u.password = weakPassword;
        return u;
    }

    function weakPassword() {
        var weakPassword = randomWeakPassword(10);
        var u = validUser();
        u.password = weakPassword;
        return u;
    }

    function shortPhone() {
        var u = validUser();
        u.phone = randomPhone(1);
        return u;
    }

    function longPhone() {
        var u = validUser();
        u.phone = randomPhone(100);
        return u;
    }

    function longFirstName() {
        var u = validUser();
        u.first_name = randomString(500000);
        return u;
    }

    function longLastName() {
        var u = validUser();
        u.last_name = randomString(500000);
        return u;
    }

    function validLoginUser() {
        var u = validUser();

        return {
            email: u.email,
            password: u.password
        };
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

    // derive login request from register request
    function toLoginUser(registerUser) {
        return {
            email: registerUser.email,
            password: registerUser.password
        };
    }

    return {
        validUser: validUser,
        missingFirstName: missingFirstName,
        missingLastName: missingLastName,
        missingEmail: missingEmail,
        missingPassword: missingPassword,
        missingPhone: missingPhone,
        shortLastName: shortLastName,
        shortPassword: shortPassword,
        weakPassword: weakPassword,
        shortPhone: shortPhone,
        longPhone: longPhone,
        longFirstName: longFirstName,
        longLastName: longLastName,
        missingLoginEmail: missingLoginEmail,
        missingLoginPassword: missingLoginPassword,
        validLoginUser: validLoginUser,
        toLoginUser: toLoginUser
    };
}