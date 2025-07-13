import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;

public class StaffDashboardLoginTest {

    WebDriver driver;
    WebDriverWait wait;

    @BeforeEach
    void setUp() {
        WebDriverManager.chromedriver().setup();
        driver = new ChromeDriver();
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        driver.manage().window().maximize();
    }

    @Test
    void loginAndGoToDashboard() {
        driver.get("http://localhost:9090/OishipFoodOrdering/login");

        // Nhập email và mật khẩu staff
        driver.findElement(By.id("email")).sendKeys("staff1@example.com");
        driver.findElement(By.id("password")).sendKeys("staff");

        // Click nút login
        driver.findElement(By.cssSelector("button[type='submit']")).click();

        // Đợi điều hướng hoặc chuyển trang
        wait.until(ExpectedConditions.urlContains("/staff/dashboard"));

        // Xác nhận đã vào dashboard
        Assertions.assertTrue(driver.getCurrentUrl().contains("/staff/dashboard"));
    }

    @AfterEach
    void tearDown() throws InterruptedException {
        Thread.sleep(3000);
        if (driver != null) {
            driver.quit();
        }
    }
}
