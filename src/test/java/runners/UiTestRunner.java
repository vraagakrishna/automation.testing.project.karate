package runners;

import com.intuit.karate.junit5.Karate;
import hooks.ScenarioLoggerHook;


public class UiTestRunner {

    @Karate.Test
    Karate ui() {
        return Karate.run("classpath:")
                     .tags("@ui")
                     .hook(new ScenarioLoggerHook())
                     .outputHtmlReport(true);
    }

}
