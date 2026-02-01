function fn() {
    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);

    karate.configure('printEnabled', true);

    karate.configure('driver', { showDriverLog: false });

    var headless = (karate.properties['headless'] !== 'false') || true;

    var driverConfig = {
        type: 'chrome',
        addOptions: [
            '--window-size=1920,1080'
        ],
        screenshotOnFailure: true,
        showBrowserLog: false,
        headless: headless,
    };

    karate.log('Headless: ', headless);

    var config = {
        baseUrl: 'https://www.edendalesports.co.za/EDENDALESPORTSPROJECTNPC/api',
        soapUrl: 'https://www.crcind.com/csp/samples/SOAP.Demo.cls',
        uiUrl: 'https://edendalesportsprojectnpc.vercel.app/',
        driverConfig: driverConfig
    };

    return config;
}