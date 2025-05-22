package utils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class Util {
    /**
     * Helper method to log error into [ROOT_DIRECTORY]/logs/error.log.
     *
     * @param message - String message
     */
    public static void logError(String message) {
        try {
            File file = new File("logs/error.log"); // Write to a "logs" folder in the project root
            // Ensure directory exists
            file.getParentFile().mkdirs();

            // Create file writer
            FileWriter writer;
            writer = new FileWriter(file, true); // true means the message will be appended instead of rewrite
            writer.write(message + System.lineSeparator());
            writer.close();
        } catch (IOException ex) {
        }
    }
}
