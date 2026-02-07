package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import hooks.ScenarioLoggerHook;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;


public class ApiTestRunner {

    @Test
    void api() {
        Results results = Runner.path("classpath:")
                                .tags("@api")
                                .hook(new ScenarioLoggerHook())
                                .outputHtmlReport(true)
                                .outputCucumberJson(true)
                                .parallel(1);

        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

}
