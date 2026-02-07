package runners;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class KarateReportRunner {

    @Test
    void generateSingleSummaryReport() throws IOException {
        File reportDir = new File("target");

        Collection<File> jsonFiles = findAllKarateJsonFiles(reportDir);

        if (jsonFiles.isEmpty())
            throw new RuntimeException("No Cucumber JSON files found under target");

        List<String> jsonPaths = jsonFiles.stream()
                                          .map(File::getAbsolutePath)
                                          .toList();

        // Output the merged report into ONE place
        File outputDir = new File("target/karate-merged-report");

        Configuration config = new Configuration(outputDir, "Automation Test Report");

        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);

        reportBuilder.generateReports();

        copyAllResFolders(reportDir, outputDir);

        Files.copy(
                Path.of("target/karate-merged-report/cucumber-html-reports/overview-features.html"),
                Path.of("target/karate-merged-report/cucumber-html-reports/index.html"),
                StandardCopyOption.REPLACE_EXISTING
        );
    }

    private static Collection<File> findAllKarateJsonFiles(File root) {
        List<File> jsonFiles = new ArrayList<>();

        File[] files = root.listFiles();

        if (files == null)
            return jsonFiles;

        for (File f : files) {
            // Only dive into karate-reports* folders
            if (f.isDirectory() && f.getName()
                                    .startsWith("karate-reports")) {
                jsonFiles.addAll(findJsonFilesRecursively(f));
            }
        }

        return jsonFiles;
    }

    private static Collection<File> findJsonFilesRecursively(File dir) {
        List<File> jsonFiles = new ArrayList<>();

        File[] files = dir.listFiles();

        if (files == null)
            return jsonFiles;

        for (File f : files) {
            if (f.isDirectory())
                jsonFiles.addAll(findJsonFilesRecursively(f));
            else if (f.isFile() && f.getName()
                                    .endsWith(".json"))
                jsonFiles.add(f);
        }

        return jsonFiles;
    }

    private static void copyAllResFolders(File targetDir, File mergedOutputDir) throws IOException {
        File cucumberOutput = new File(mergedOutputDir, "cucumber-html-reports/res");

        if (!cucumberOutput.exists())
            cucumberOutput.mkdirs();

        File[] karateReportDirs = targetDir.listFiles(
                f -> f.isDirectory() && f.getName()
                                         .startsWith("karate-reports")
        );

        if (karateReportDirs == null) return;

        for (File reportDir : karateReportDirs) {
            File resDir = new File(reportDir, "res");
            if (resDir.exists())
                copyDirectory(resDir.toPath(), cucumberOutput.toPath());
        }
    }

    private static void copyDirectory(Path source, Path target) throws IOException {
        Files.walk(source)
             .forEach(path -> {
                 try {
                     Path relative = source.relativize(path);
                     Path dest = target.resolve(relative);

                     if (Files.isDirectory(path))
                         Files.createDirectories(dest);
                     else
                         Files.copy(path, dest, StandardCopyOption.REPLACE_EXISTING);
                 } catch (IOException e) {
                     throw new RuntimeException(e);
                 }
             });
    }

}
