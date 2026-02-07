package runners;

import com.intuit.karate.junit5.Karate;
import hooks.ScenarioLoggerHook;


public class SoapTestRunner {

    @Karate.Test
    Karate soap() {
        return Karate.run("classpath:")
                     .tags("@soap")
                     .hook(new ScenarioLoggerHook())
                     .outputHtmlReport(true)
                     .outputCucumberJson(true);
    }

}
