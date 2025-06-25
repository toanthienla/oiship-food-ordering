package model;

public class ChartData {
    private String label; // Ví dụ: "01/2025"
    private int value;   // Ví dụ: số lượng đơn hàng, món ăn, hoặc tổng tiền

    public ChartData() {
    }

    public ChartData(String label, int value) {
        this.label = label;
        this.value = value;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return "ChartData{label='" + label + "', value=" + value + "}";
    }
}