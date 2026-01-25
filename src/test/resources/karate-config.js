function fn() {
    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);

    karate.configure('printEnabled', true);

    var config = {
        baseUrl: 'https://www.ndosiautomation.co.za/API',
        soapUrl: 'https://www.crcind.com/csp/samples/SOAP.Demo.cls'
    };

    return config;
}