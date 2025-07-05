package utils.service.paymentconfig;

import vn.payos.PayOS;

public class PayOSConfig {

    private static PayOS payOSInstance;

    // Private constructor to prevent instantiation
    private PayOSConfig() {
    }

    // Thread-safe singleton method to get PayOS instance
    public static synchronized PayOS getPayOS() {
        if (payOSInstance == null) {
            // Replace with actual PayOS configuration (e.g., client ID, API key, checksum key)
            payOSInstance = new PayOS("a7cb7380-c77a-4f52-bbf8-dbe3f6f72e7e", "03860695-a868-4a05-bebc-5c7bc2426c85", "934b2ab1d4688c20514b7b1f980afc1a42940619a17f9ce956b3318b3ac506ba");
        }
        return payOSInstance;
    }
}