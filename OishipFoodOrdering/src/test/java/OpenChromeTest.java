import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import io.github.bonigarcia.wdm.WebDriverManager;

public class OpenChromeTest {
    public static void main(String[] args) {
        WebDriverManager.chromedriver().setup(); // Tự động tải driver
        WebDriver driver = new ChromeDriver();   // Mở Chrome
        driver.get("https://google.com");        // Truy cập trang
    }
}
