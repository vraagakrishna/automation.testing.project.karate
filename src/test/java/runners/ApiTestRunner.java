package runners;

import com.intuit.karate.junit5.Karate;

public class ApiTestRunner {

    @Karate.Test
    Karate api() {
        return Karate.run("classpath:")
                     .tags("@api");
    }


}
