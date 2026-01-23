package hooks;

import com.intuit.karate.RuntimeHook;
import com.intuit.karate.core.Feature;
import com.intuit.karate.core.Scenario;
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
}
