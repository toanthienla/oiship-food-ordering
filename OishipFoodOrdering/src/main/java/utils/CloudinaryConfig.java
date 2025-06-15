package utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import io.github.cdimascio.dotenv.Dotenv;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

public class CloudinaryConfig {

    private static final Dotenv dotenv = Dotenv.configure()
            .filename(".env")
            .load();

    public static final String CLOUDINARY_CLOUD_NAME = dotenv.get("CLOUDINARY_CLOUD_NAME");
    public static final String CLOUDINARY_API_KEY = dotenv.get("CLOUDINARY_API_KEY");
    public static final String CLOUDINARY_API_SECRET = dotenv.get("CLOUDINARY_API_SECRET");

    public static String uploadImage(InputStream inputStream, String fileName) throws IOException {
        Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", CLOUDINARY_CLOUD_NAME,
                "api_key", CLOUDINARY_API_KEY,
                "api_secret", CLOUDINARY_API_SECRET
        ));

        // Convert InputStream to byte[]
        byte[] bytes = inputStream.readAllBytes();

        Map<String, Object> options = new HashMap<>();
        options.put("public_id", "dishes/" + fileName);
        options.put("resource_type", "image");

        Map<?, ?> result = cloudinary.uploader().upload(bytes, options);
        return (String) result.get("secure_url");
    }
}
