package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import hooks.ScenarioLoggerHook;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class FullTestRunner {

    @Test
    void runAllTests() {
        Results results = Runner.builder()
                                .path("classpath:")
                                .tags("~@ignore", "~@perf")
                                .hook(new ScenarioLoggerHook())
                                .outputHtmlReport(true)
                                .outputCucumberJson(true)
                                .parallel(1);

        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

}
