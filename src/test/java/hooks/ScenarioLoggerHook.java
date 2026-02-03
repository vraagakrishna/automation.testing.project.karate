package hooks;

import com.intuit.karate.RuntimeHook;
import com.intuit.karate.core.Feature;
import com.intuit.karate.core.Scenario;
import com.intuit.karate.core.ScenarioResult;
import com.intuit.karate.core.ScenarioRuntime;

public class ScenarioLoggerHook implements RuntimeHook {

    @Override
    public boolean beforeScenario(ScenarioRuntime sr) {
        Scenario scenario = sr.scenario;
        String scenarioName = scenario.getName();

        if (scenarioName.isEmpty())
            return true;

        Feature feature = sr.featureRuntime.featureCall.feature;

        System.out.println("========================================");
        System.out.println(">> Feature : " + feature.getName());
        System.out.println(">> Scenario: " + scenarioName);
        System.out.println(">> Tags    : " + scenario.getTags());
        System.out.println("========================================");

        return true;
    }

    @Override
    public void afterScenario(ScenarioRuntime sr) {
        Scenario scenario = sr.scenario;
        ScenarioResult result = sr.result;

        if (scenario.getName().isEmpty())
            return;

        System.out.println("---------- Scenario Result ----------");
        System.out.println(">> Scenario: " + scenario.getName());

        if (result.isFailed()) {
            System.out.println(">> Status  : FAILED");

            // Print failure message(s)
            System.out.println(">> Error(s):");
            System.out.println(result.getErrorMessage());
        }
        else
            System.out.println(">> Status  : PASSED");

        System.out.println("-------------------------------------");
    }

}
