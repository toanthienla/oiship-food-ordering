package dao;

import utils.OAuthConstants;
import model.GoogleAccount;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

public class GoogleOAuthDAO {
    public static String getToken(String code) throws ClientProtocolException, IOException {
        String response = Request.Post(OAuthConstants.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id", OAuthConstants.GOOGLE_CLIENT_ID)
                        .add("client_secret", OAuthConstants.GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", OAuthConstants.GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", OAuthConstants.GOOGLE_GRANT_TYPE)
                        .build())
                .execute().returnContent().asString();

        System.out.println("Response from token request: " + response);

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);

        if (jobj.get("access_token") == null) {
            throw new RuntimeException("No access token found in response: " + response);
        }

        return jobj.get("access_token").getAsString();
    }

    public static GoogleAccount getUserInfo(final String accessToken) throws ClientProtocolException, IOException {

        String link = OAuthConstants.GOOGLE_LINK_GET_USER_INFO + accessToken;

        String response = Request.Get(link).execute().returnContent().asString();

        GoogleAccount googlePojo = new Gson().fromJson(response, GoogleAccount.class);

        return googlePojo;

    }
}
