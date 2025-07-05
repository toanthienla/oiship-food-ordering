package model.paymentModel;

public class CreatePaymentLinkRequestBody {
    private String productName;
    private String description;
    private String returnUrl;
    private int price;
    private String cancelUrl;

    public CreatePaymentLinkRequestBody(String productName, String description, String returnUrl, int price, String cancelUrl) {
        this.productName = productName;
        this.description = description;
        this.returnUrl = returnUrl;
        this.price = price;
        this.cancelUrl = cancelUrl;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getReturnUrl() {
        return returnUrl;
    }

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = returnUrl;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getCancelUrl() {
        return cancelUrl;
    }

    public void setCancelUrl(String cancelUrl) {
        this.cancelUrl = cancelUrl;
    }
}