package utils;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;
import model.Ingredient;

public class TotalPriceCalculator {

    // ✅ Tính tổng chi phí nguyên liệu từ danh sách Ingredient
    public static BigDecimal calculateIngredientCost(List<Ingredient> ingredients) {
        if (ingredients == null || ingredients.isEmpty()) {
            return BigDecimal.ZERO;
        }

        BigDecimal totalCost = BigDecimal.ZERO;
        for (Ingredient ing : ingredients) {
            if (ing.getUnitCost() != null) {
                BigDecimal quantity = BigDecimal.valueOf(ing.getQuantity());
                BigDecimal cost = ing.getUnitCost().multiply(quantity);
                totalCost = totalCost.add(cost);
            }
        }
        return totalCost;
    }

    
    
    // Tính tổng giá bán từ các chi phí
    public static BigDecimal calculateTotalPrice(BigDecimal opCost, BigDecimal interestPercentage, BigDecimal ingredientCost) {
        if (opCost == null) {
            opCost = BigDecimal.ZERO;
        }
        if (interestPercentage == null) {
            interestPercentage = BigDecimal.ZERO;
        }
        if (ingredientCost == null) {
            ingredientCost = BigDecimal.ZERO;
        }

        // (ingredientCost + opCost) * (1 + interest %)
        BigDecimal total = ingredientCost.add(opCost);
        BigDecimal interest = BigDecimal.ONE.add(interestPercentage.divide(new BigDecimal("100")));
        BigDecimal result = total.multiply(interest);

        // Làm tròn đến bội số 1,000
        return result.divide(new BigDecimal("1000"), 0, RoundingMode.UP).multiply(new BigDecimal("1000"));
    }

    // Định dạng kiểu VND, ví dụ: 35000 -> "35.000"
    public static String formatVND(BigDecimal amount) {
        if (amount == null) {
            return "0";
        }
        return NumberFormat.getInstance(new Locale("vi", "VN")).format(amount);
    }
}
