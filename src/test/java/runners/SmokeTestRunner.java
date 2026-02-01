package runners;

import com.intuit.karate.junit5.Karate;
import hooks.ScenarioLoggerHook;

public class SmokeTestRunner {

    @Karate.Test
    Karate smoke() {
        return Karate.run("classpath:")
                     .tags("@smoke")
                     .hook(new ScenarioLoggerHook());
    }

}
