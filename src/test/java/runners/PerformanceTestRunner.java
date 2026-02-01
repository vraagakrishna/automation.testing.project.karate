package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;
import hooks.ScenarioLoggerHook;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class PerformanceTestRunner {

    @Test
    void apiPerformance() {
        Results results = Runner.path("classpath:")
                                .tags("@perf", "@api")
                                .hook(new ScenarioLoggerHook())
                                .parallel(10);

        assertEquals(0, results.getFailCount(), results.getErrorMessages());

        assertTrue(results.getTimeTakenMillis() < 30_000,
                "API performance test took too long");
    }

    @Karate.Test
    Karate uiPerformance() {
        return Karate.run("classpath:")
                     .tags("@perf", "@ui")
                     .hook(new ScenarioLoggerHook())
                     .outputHtmlReport(true);
    }

}
