package utils;

import io.github.cdimascio.dotenv.Dotenv;

public class OAuthConstants {
    private static final Dotenv dotenv = Dotenv.configure()
            .filename(".env")
            .load();

    public static final String GOOGLE_CLIENT_ID = dotenv.get("GOOGLE_CLIENT_ID");
    public static final String GOOGLE_CLIENT_SECRET = dotenv.get("GOOGLE_CLIENT_SECRET");
    public static final String GOOGLE_REDIRECT_URI = dotenv.get("GOOGLE_REDIRECT_URI");
    public static final String GOOGLE_GRANT_TYPE = dotenv.get("GOOGLE_GRANT_TYPE");
    public static final String GOOGLE_LINK_GET_TOKEN = dotenv.get("GOOGLE_LINK_GET_TOKEN");
    public static final String GOOGLE_LINK_GET_USER_INFO = dotenv.get("GOOGLE_LINK_GET_USER_INFO");
}
