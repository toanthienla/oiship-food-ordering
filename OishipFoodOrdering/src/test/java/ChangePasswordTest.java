//
//import io.github.bonigarcia.wdm.WebDriverManager;
//import org.junit.jupiter.api.*;
//import org.openqa.selenium.*;
//import org.openqa.selenium.chrome.ChromeDriver;
//import org.openqa.selenium.chrome.ChromeOptions;
//import org.openqa.selenium.support.ui.ExpectedConditions;
//import org.openqa.selenium.support.ui.WebDriverWait;
//
//import java.time.Duration;
//import java.util.HashMap;
//import java.util.Map;
//
//@TestInstance(TestInstance.Lifecycle.PER_CLASS)
//public class ChangePasswordTest {
//
//    private WebDriver driver;
//    private WebDriverWait wait;
//    private final String baseUrl = "http://localhost:9090/OishipFoodOrdering";
//
//    @BeforeEach
//    void setUp() {
//        WebDriverManager.chromedriver().setup();
//
//        ChromeOptions options = new ChromeOptions();
//
//        // ✅ Tắt popup Google Password Manager
//        Map<String, Object> prefs = new HashMap<>();
//        prefs.put("profile.password_manager_leak_detection", false);
//        prefs.put("credentials_enable_service", false);
//        prefs.put("profile.password_manager_enabled", false);
//        options.setExperimentalOption("prefs", prefs);
//
//        options.addArguments("--disable-notifications");
//
//        driver = new ChromeDriver(options);
//        driver.manage().window().maximize();
//        wait = new WebDriverWait(driver, Duration.ofSeconds(20));
//
//        loginAsStaff();
//        driver.get(baseUrl + "/staff/profile/change-password");
//        wait.until(ExpectedConditions.urlContains("/change-password"));
//    }
//
//    void loginAsStaff() {
//        driver.get(baseUrl + "/login");
//
//        safeSendKeys(By.id("email"), "staff1@example.com");
//        safeSendKeys(By.id("password"), "staff");
//
//        driver.findElement(By.cssSelector("button[type='submit']")).click();
//        wait.until(ExpectedConditions.urlContains("/staff/dashboard"));
//    }
//
//    @AfterEach
//    void tearDown() {
//        if (driver != null) {
//            driver.quit();
//        }
//    }
//
//    @Test
//    void testWrongCurrentPassword() {
//        safeSendKeys(By.id("currentPassword"), "wrongpassword");
//        safeSendKeys(By.id("newPassword"), "newpass123");
//        safeSendKeys(By.id("confirmPassword"), "newpass123");
//        driver.findElement(By.cssSelector("button[type='submit']")).click();
//
//        WebElement errorAlert = wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".alert-danger")));
//        Assertions.assertTrue(errorAlert.getText().contains("Current password is incorrect"));
//    }
//
//    @Test
//    void testMismatchedNewPasswords() {
//        safeSendKeys(By.id("currentPassword"), "staff");
//        safeSendKeys(By.id("newPassword"), "newpass123");
//        safeSendKeys(By.id("confirmPassword"), "wrongconfirm");
//        driver.findElement(By.cssSelector("button[type='submit']")).click();
//
//        WebElement errorAlert = wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".alert-danger")));
//        Assertions.assertTrue(errorAlert.getText().toLowerCase().contains("do not match"));
//    }
//
//    @Test
//    void testSuccessfulPasswordChangeAndRevert() {
//        // Đổi sang mật khẩu mới
//        safeSendKeys(By.id("currentPassword"), "staff");
//        safeSendKeys(By.id("newPassword"), "temp1234");
//        safeSendKeys(By.id("confirmPassword"), "temp1234");
//        driver.findElement(By.cssSelector("button[type='submit']")).click();
//
//        WebElement successAlert = wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".alert-success")));
//        Assertions.assertTrue(successAlert.getText().toLowerCase().contains("successfully"));
//
//        // Đăng xuất
//        driver.findElement(By.linkText("Logout")).click();
//        wait.until(ExpectedConditions.urlContains("/home"));
//
//        // Mở dropdown Guest
//        driver.findElement(By.id("userDropdown")).click();
//
//        // Click vào "Log in"
//        WebElement loginOption = wait.until(ExpectedConditions.elementToBeClickable(By.linkText("Log in")));
//        loginOption.click();
//
//        // Đảm bảo đang ở trang login
//        wait.until(ExpectedConditions.urlContains("/login"));
//
//        // Đăng nhập lại bằng mật khẩu mới
//        loginWithPassword("staff1@example.com", "temp1234");
//
//        // Quay lại đổi lại mật khẩu cũ
//        driver.get(baseUrl + "/staff/profile/change-password");
//        wait.until(ExpectedConditions.urlContains("/change-password"));
//
//        safeSendKeys(By.id("currentPassword"), "temp1234");
//        safeSendKeys(By.id("newPassword"), "staff");
//        safeSendKeys(By.id("confirmPassword"), "staff");
//        driver.findElement(By.cssSelector("button[type='submit']")).click();
//
//        WebElement revertAlert = wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".alert-success")));
//        Assertions.assertTrue(revertAlert.getText().toLowerCase().contains("successfully"));
//    }
//
//    void loginWithPassword(String email, String password) {
//        driver.get(baseUrl + "/login");
//        safeSendKeys(By.id("email"), email);
//        safeSendKeys(By.id("password"), password);
//        driver.findElement(By.cssSelector("button[type='submit']")).click();
//        wait.until(ExpectedConditions.urlContains("/staff/dashboard"));
//    }
//
//    // Helper method để gửi text sau khi chắc chắn element hiển thị
//    void safeSendKeys(By locator, String value) {
//        WebElement element = wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
//        element.clear(); // optional: xóa nếu có giá trị cũ
//        element.sendKeys(value);
//    }
//}
