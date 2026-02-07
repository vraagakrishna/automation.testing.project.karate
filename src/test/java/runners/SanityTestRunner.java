package runners;

import com.intuit.karate.junit5.Karate;
import hooks.ScenarioLoggerHook;

public class SanityTestRunner {

    @Karate.Test
    Karate sanity() {
        return Karate.run("classpath:")
                     .tags("@sanity")
                     .hook(new ScenarioLoggerHook())
                     .outputHtmlReport(true)
                     .outputCucumberJson(true);
    }

}
