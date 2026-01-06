# Open/Closed Principle (OCP) Testing Workshop

## Objective

Learn to identify OCP violations, write tests for extensible code, and refactor using strategies and polymorphism to enable extension without modification.

## Prerequisites

- Complete [SRP Workshop](./01-SRP-WORKSHOP.md)
- Understand strategy pattern and polymorphism

## The Problem

The `DiscountCalculator` in the reference application uses a large switch statement to handle different discount types. Adding new discount types requires modifying existing code.

## Workshop Steps

### Step 1: Write Characterization Tests (20 minutes)

**Current Implementation**:
```java
public class DiscountCalculator {
    public Money calculateDiscount(Order order, String discountType) {
        switch (discountType) {
            case "PERCENTAGE":
                return order.getTotal().multiply(0.10);
            case "FIXED":
                return new Money(10.00);
            case "BOGO":
                return calculateBuyOneGetOne(order);
            default:
                return Money.ZERO;
        }
    }
}
```

**Tests**:
```java
@ParameterizedTest
@CsvSource({
    "PERCENTAGE, 100.00, 10.00",
    "FIXED, 100.00, 10.00",
    "BOGO, 100.00, 50.00"
})
void calculateDiscount_shouldReturnCorrectAmount(
    String type, BigDecimal total, BigDecimal expected
) {
    DiscountCalculator calculator = new DiscountCalculator();
    Order order = new Order(new Money(total));
    
    Money discount = calculator.calculateDiscount(order, type);
    
    assertEquals(expected, discount.getAmount());
}
```

### Step 2: Create Strategy Interface (15 minutes)

```java
public interface DiscountStrategy {
    Money calculateDiscount(Order order);
    String getDescription();
}
```

**Test the Interface Contract**:
```java
public abstract class DiscountStrategyContractTest {
    protected abstract DiscountStrategy createStrategy();
    
    @Test
    void calculateDiscount_shouldNotReturnNull() {
        DiscountStrategy strategy = createStrategy();
        Order order = new Order(new Money(100));
        
        Money discount = strategy.calculateDiscount(order);
        
        assertNotNull(discount);
    }
    
    @Test
    void calculateDiscount_shouldNotReturnNegative() {
        DiscountStrategy strategy = createStrategy();
        Order order = new Order(new Money(100));
        
        Money discount = strategy.calculateDiscount(order);
        
        assertTrue(discount.getAmount().compareTo(BigDecimal.ZERO) >= 0);
    }
}
```

### Step 3: Implement Concrete Strategies (60 minutes)

**PercentageDiscount**:
```java
public class PercentageDiscount implements DiscountStrategy {
    private final BigDecimal percentage;
    
    public PercentageDiscount(BigDecimal percentage) {
        this.percentage = percentage;
    }
    
    @Override
    public Money calculateDiscount(Order order) {
        return order.getTotal().multiply(percentage.divide(new BigDecimal(100)));
    }
    
    @Override
    public String getDescription() {
        return percentage + "% off";
    }
}
```

**Tests**:
```java
class PercentageDiscountTest extends DiscountStrategyContractTest {
    @Override
    protected DiscountStrategy createStrategy() {
        return new PercentageDiscount(new BigDecimal("10"));
    }
    
    @ParameterizedTest
    @CsvSource({
        "10, 100.00, 10.00",
        "20, 50.00, 10.00",
        "15, 200.00, 30.00"
    })
    void calculateDiscount_shouldCalculatePercentage(
        BigDecimal percentage, BigDecimal total, BigDecimal expected
    ) {
        DiscountStrategy strategy = new PercentageDiscount(percentage);
        Order order = new Order(new Money(total));
        
        Money discount = strategy.calculateDiscount(order);
        
        assertEquals(expected, discount.getAmount());
    }
}
```

**FixedAmountDiscount**:
```java
public class FixedAmountDiscount implements DiscountStrategy {
    private final Money amount;
    
    public FixedAmountDiscount(Money amount) {
        this.amount = amount;
    }
    
    @Override
    public Money calculateDiscount(Order order) {
        return amount;
    }
    
    @Override
    public String getDescription() {
        return "$" + amount + " off";
    }
}
```

### Step 4: Refactor Calculator (30 minutes)

```java
public class DiscountCalculator {
    private final Map<String, DiscountStrategy> strategies;
    
    public DiscountCalculator(Map<String, DiscountStrategy> strategies) {
        this.strategies = strategies;
    }
    
    public Money calculateDiscount(Order order, String discountType) {
        DiscountStrategy strategy = strategies.get(discountType);
        if (strategy == null) {
            return Money.ZERO;
        }
        return strategy.calculateDiscount(order);
    }
}
```

**Tests**:
```java
@Test
void calculateDiscount_shouldUseCorrectStrategy() {
    Map<String, DiscountStrategy> strategies = Map.of(
        "PERCENTAGE", new PercentageDiscount(new BigDecimal("10")),
        "FIXED", new FixedAmountDiscount(new Money(10))
    );
    
    DiscountCalculator calculator = new DiscountCalculator(strategies);
    Order order = new Order(new Money(100));
    
    Money discount = calculator.calculateDiscount(order, "PERCENTAGE");
    
    assertEquals(new BigDecimal("10.00"), discount.getAmount());
}
```

### Step 5: Add New Strategy Without Modification (20 minutes)

**SeasonalDiscount** (NEW - no modification to existing code):
```java
public class SeasonalDiscount implements DiscountStrategy {
    private final BigDecimal multiplier;
    private final LocalDate startDate;
    private final LocalDate endDate;
    
    @Override
    public Money calculateDiscount(Order order) {
        if (isInSeason()) {
            return order.getTotal().multiply(multiplier);
        }
        return Money.ZERO;
    }
    
    private boolean isInSeason() {
        LocalDate now = LocalDate.now();
        return !now.isBefore(startDate) && !now.isAfter(endDate);
    }
}
```

**Tests**:
```java
class SeasonalDiscountTest extends DiscountStrategyContractTest {
    @Override
    protected DiscountStrategy createStrategy() {
        return new SeasonalDiscount(
            new BigDecimal("0.20"),
            LocalDate.now().minusDays(1),
            LocalDate.now().plusDays(1)
        );
    }
    
    @Test
    void calculateDiscount_shouldApplyDiscountDuringSeason() {
        DiscountStrategy strategy = new SeasonalDiscount(
            new BigDecimal("0.20"),
            LocalDate.now().minusDays(1),
            LocalDate.now().plusDays(1)
        );
        Order order = new Order(new Money(100));
        
        Money discount = strategy.calculateDiscount(order);
        
        assertEquals(new BigDecimal("20.00"), discount.getAmount());
    }
    
    @Test
    void calculateDiscount_shouldNotApplyDiscountOutsideSeason() {
        DiscountStrategy strategy = new SeasonalDiscount(
            new BigDecimal("0.20"),
            LocalDate.now().plusDays(1),
            LocalDate.now().plusDays(30)
        );
        Order order = new Order(new Money(100));
        
        Money discount = strategy.calculateDiscount(order);
        
        assertEquals(BigDecimal.ZERO, discount.getAmount());
    }
}
```

### Step 6: Verify Extension (15 minutes)

**Success Criteria**:
- [ ] Added new discount type without modifying existing code
- [ ] All existing tests still pass
- [ ] New strategy has comprehensive tests
- [ ] Contract tests pass for new strategy

## Comparison

### Before OCP
```java
// Adding new discount requires modifying this method
switch (discountType) {
    case "PERCENTAGE": // ...
    case "FIXED": // ...
    case "BOGO": // ...
    case "SEASONAL": // NEW - must modify existing code
}
```

### After OCP
```java
// Adding new discount: just create new class
public class SeasonalDiscount implements DiscountStrategy {
    // No modification to existing code needed
}

// Register in configuration
strategies.put("SEASONAL", new SeasonalDiscount(...));
```

## Benefits

- ✅ Add new discount types without modifying existing code
- ✅ Each strategy is independently testable
- ✅ Easy to understand and maintain
- ✅ Follows Single Responsibility Principle
- ✅ Strategies are reusable

## Assessment Checklist

- [ ] All discount types extracted to strategies
- [ ] Contract tests defined and passing
- [ ] Each strategy has comprehensive tests
- [ ] Calculator uses strategy pattern
- [ ] New strategy added without modifying existing code
- [ ] All original tests still pass
- [ ] Code is more maintainable

## Next Steps

1. Apply OCP to other switch statements in the codebase
2. Move to [LSP Workshop](./03-LSP-WORKSHOP.md)

---

**Key Takeaway**: OCP enables extension through new code, not modification of existing code. Use strategies and polymorphism to achieve this.
