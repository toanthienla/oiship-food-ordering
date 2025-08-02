package utils.service.paymentconfig;

import vn.payos.PayOS;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PayOSConfig {

    private static PayOS payOSInstance;

    // Private constructor to prevent instantiation
    private PayOSConfig() {
    }

    // Thread-safe singleton method to get PayOS instance
    public static synchronized PayOS getPayOS() {
        if (payOSInstance == null) {
            Properties props = new Properties();
            try (InputStream input = PayOSConfig.class.getClassLoader()
                    .getResourceAsStream(".env")) {

                if (input == null) {
                    throw new RuntimeException("Cannot find .env file in resources.");
                }

                props.load(input);

                String clientId = props.getProperty("PAYOS_CLIENT_ID");
                String apiKey = props.getProperty("PAYOS_API_KEY");
                String checksumKey = props.getProperty("PAYOS_CHECKSUM_KEY");

                if (clientId == null || apiKey == null || checksumKey == null) {
                    throw new RuntimeException("Missing PayOS configuration in .env file.");
                }

                payOSInstance = new PayOS(clientId, apiKey, checksumKey);

            } catch (IOException e) {
                throw new RuntimeException("Failed to load PayOS configuration", e);
            }
        }
        return payOSInstance;
    }
}
