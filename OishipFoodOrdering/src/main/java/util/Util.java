package util;

import com.google.common.hash.Hashing;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

public class Util {

    /**
     * Method for getting the SHA256 hash of a String.
     *
     * @param str - The original String
     * @return - Th hashed String
     */
    public static String hash(String str) {
        //Reason we don't use MessageDigest class is that it's not thread safe
        return Hashing.sha256().hashString(str, StandardCharsets.UTF_8).toString();
    }

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

            //Create file writer 
            FileWriter writer;
            writer = new FileWriter(file, true); //true means the message will be appended instead of rewrite
            writer.write(message + System.lineSeparator());
            writer.close();
        } catch (IOException ex) {
        }
    }
}
