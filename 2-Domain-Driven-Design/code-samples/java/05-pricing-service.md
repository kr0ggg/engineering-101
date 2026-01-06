# Pricing Service - Java Example

**Section**: [Domain Services and Domain Service Design Principles](../../1-introduction-to-the-domain.md#domain-services-and-domain-service-design-principles)

**Navigation**: [← Previous: EmailAddress Value Object](./04-email-address-value-object.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - Pricing Service Domain Service
// File: 2-Domain-Driven-Design/code-samples/java/05-pricing-service.java

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

// ✅ GOOD: Domain Service for Complex Business Logic
public class PricingService {
    private final TaxCalculator taxCalculator;
    private final ShippingCalculator shippingCalculator;
    private final DiscountRuleRepository discountRuleRepository;
    
    public PricingService(
            TaxCalculator taxCalculator,
            ShippingCalculator shippingCalculator,
            DiscountRuleRepository discountRuleRepository) {
        this.taxCalculator = taxCalculator;
        this.shippingCalculator = shippingCalculator;
        this.discountRuleRepository = discountRuleRepository;
    }
    
    // ✅ Main business operation - calculates total order amount
    public Money calculateOrderTotal(Order order, Customer customer, Address shippingAddress) {
        if (!customer.isActive()) {
            throw new IllegalArgumentException("Cannot calculate pricing for inactive customer");
        }
        
        // Start with base order amount
        Money baseAmount = order.getTotalAmount();
        
        // Apply customer-specific discount
        Money discountedAmount = applyCustomerDiscount(baseAmount, customer);
        
        // Apply bulk discount
        Money bulkDiscountedAmount = applyBulkDiscount(discountedAmount, order);
        
        // Calculate tax
        Money taxAmount = taxCalculator.calculateTax(bulkDiscountedAmount, shippingAddress);
        
        // Calculate shipping
        Money shippingAmount = shippingCalculator.calculateShipping(order, shippingAddress);
        
        // Apply shipping discount if applicable
        Money finalShipping = applyShippingDiscount(shippingAmount, bulkDiscountedAmount);
        
        // Calculate final total
        Money finalTotal = bulkDiscountedAmount.add(taxAmount).add(finalShipping);
        
        return finalTotal;
    }
    
    // ✅ Business operation - calculates discount amount
    public Money calculateDiscountAmount(Order order, Customer customer) {
        Money baseAmount = order.getTotalAmount();
        Money discountedAmount = applyCustomerDiscount(baseAmount, customer);
        Money bulkDiscountedAmount = applyBulkDiscount(discountedAmount, order);
        
        Money totalDiscount = baseAmount.subtract(bulkDiscountedAmount);
        return totalDiscount;
    }
    
    // ✅ Business operation - gets available discounts
    public List<Discount> getAvailableDiscounts(Order order, Customer customer) {
        List<Discount> discounts = new ArrayList<>();
        
        // Customer type discount
        Discount customerDiscount = getCustomerTypeDiscount(customer);
        if (customerDiscount != null) {
            discounts.add(customerDiscount);
        }
        
        // Bulk discount
        Discount bulkDiscount = getBulkDiscount(order);
        if (bulkDiscount != null) {
            discounts.add(bulkDiscount);
        }
        
        // Seasonal discount
        Discount seasonalDiscount = getSeasonalDiscount();
        if (seasonalDiscount != null) {
            discounts.add(seasonalDiscount);
        }
        
        // Product discounts
        List<Discount> productDiscounts = getProductDiscounts(order);
        discounts.addAll(productDiscounts);
        
        return discounts;
    }
    
    // ✅ Private methods for complex business logic
    private Money applyCustomerDiscount(Money amount, Customer customer) {
        double discountRate = getCustomerDiscountRate(customer.getCustomerType());
        Money discountAmount = amount.multiply(discountRate);
        return amount.subtract(discountAmount);
    }
    
    private Money applyBulkDiscount(Money amount, Order order) {
        double discountRate = getBulkDiscountRate(amount.getAmount());
        Money discountAmount = amount.multiply(discountRate);
        return amount.subtract(discountAmount);
    }
    
    private Money applyShippingDiscount(Money shipping, Money orderAmount) {
        if (orderAmount.getAmount() >= 50.0) {
            return Money.zero(shipping.getCurrency()); // Free shipping
        } else if (orderAmount.getAmount() >= 25.0) {
            return shipping.multiply(0.5); // 50% off shipping
        } else {
            return shipping; // No discount
        }
    }
    
    private double getCustomerDiscountRate(String customerType) {
        return discountRuleRepository.getCustomerDiscountRate(customerType);
    }
    
    private double getBulkDiscountRate(double amount) {
        return discountRuleRepository.getBulkDiscountRate(amount);
    }
    
    private Discount getCustomerTypeDiscount(Customer customer) {
        String customerType = customer.getCustomerType();
        double discountRate = getCustomerDiscountRate(customerType);
        
        if (discountRate > 0) {
            return new Discount(
                "customer-type-" + customerType.toLowerCase(),
                customerType + " Customer Discount",
                "percentage",
                discountRate,
                "Discount for " + customerType + " customers"
            );
        }
        
        return null;
    }
    
    private Discount getBulkDiscount(Order order) {
        double amount = order.getTotalAmount().getAmount();
        double discountRate = getBulkDiscountRate(amount);
        
        if (discountRate > 0) {
            return new Discount(
                "bulk-discount",
                "Bulk Discount",
                "percentage",
                discountRate,
                String.format("%.0f%% discount for orders over $%.0f", 
                    discountRate * 100, getBulkThreshold(amount))
            );
        }
        
        return null;
    }
    
    private Discount getSeasonalDiscount() {
        // Simplified seasonal discount logic
        int currentMonth = LocalDateTime.now().getMonthValue();
        
        if (currentMonth == 12) { // December - holiday season
            return new Discount(
                "holiday-discount",
                "Holiday Discount",
                "percentage",
                0.08,
                "8% discount during holiday season"
            );
        }
        
        return null;
    }
    
    private List<Discount> getProductDiscounts(Order order) {
        List<Discount> discounts = new ArrayList<>();
        
        for (OrderItem item : order.getItems()) {
            if (item.getProductId().getValue().startsWith("SALE-")) {
                discounts.add(new Discount(
                    "sale-item-discount",
                    "Sale Item Discount",
                    "percentage",
                    0.20,
                    "20% discount on sale items"
                ));
            }
        }
        
        return discounts;
    }
    
    private double getBulkThreshold(double amount) {
        if (amount >= 1000) return 1000;
        if (amount >= 500) return 500;
        if (amount >= 100) return 100;
        return 0;
    }
}

// ✅ GOOD: Tax Calculator Domain Service
public class TaxCalculator {
    public Money calculateTax(Money amount, Address address) {
        if (address.getCountry().equals("US")) {
            return calculateUSTax(amount, address);
        } else if (address.getCountry().equals("CA")) {
            return calculateCanadianTax(amount, address);
        } else {
            return Money.zero(amount.getCurrency()); // No tax for international
        }
    }
    
    private Money calculateUSTax(Money amount, Address address) {
        double taxRate = getUSTaxRate(address.getState());
        return amount.multiply(taxRate);
    }
    
    private Money calculateCanadianTax(Money amount, Address address) {
        double taxRate = getCanadianTaxRate(address.getProvince());
        return amount.multiply(taxRate);
    }
    
    private double getUSTaxRate(String state) {
        switch (state) {
            case "CA":
            case "NY":
            case "TX":
                return 0.08; // 8% tax
            default:
                return 0.06; // 6% tax
        }
    }
    
    private double getCanadianTaxRate(String province) {
        switch (province) {
            case "ON":
            case "BC":
            case "AB":
                return 0.13; // 13% HST
            default:
                return 0.15; // 15% HST
        }
    }
}

// ✅ GOOD: Shipping Calculator Domain Service
public class ShippingCalculator {
    public Money calculateShipping(Order order, Address address) {
        Money baseShipping = getBaseShippingRate(address);
        
        // Add weight-based charges
        Money weightCharge = calculateWeightCharge(order);
        
        // Add distance-based charges
        Money distanceCharge = calculateDistanceCharge(address);
        
        // Add handling fee
        Money handlingFee = Money.of(2.99, baseShipping.getCurrency());
        
        Money totalShipping = baseShipping.add(weightCharge).add(distanceCharge).add(handlingFee);
        
        return totalShipping;
    }
    
    private Money getBaseShippingRate(Address address) {
        if (address.getCountry().equals("US")) {
            return Money.of(5.99, "USD");
        } else if (address.getCountry().equals("CA")) {
            return Money.of(8.99, "USD");
        } else {
            return Money.of(15.99, "USD");
        }
    }
    
    private Money calculateWeightCharge(Order order) {
        double totalWeight = calculateTotalWeight(order);
        
        if (totalWeight > 20) {
            return Money.of(10.00, "USD");
        } else if (totalWeight > 10) {
            return Money.of(5.00, "USD");
        } else {
            return Money.zero("USD");
        }
    }
    
    private Money calculateDistanceCharge(Address address) {
        if (address.getCountry().equals("US")) {
            if (address.getState().equals("AK") || address.getState().equals("HI")) {
                return Money.of(15.00, "USD");
            }
        }
        
        return Money.zero("USD");
    }
    
    private double calculateTotalWeight(Order order) {
        // Simplified weight calculation
        return order.getItems().stream()
                .mapToDouble(item -> item.getQuantity() * 0.5) // 0.5 lbs per item
                .sum();
    }
}

// ✅ GOOD: Discount Rule Repository
public class DiscountRuleRepository {
    public double getCustomerDiscountRate(String customerType) {
        switch (customerType) {
            case "VIP":
                return 0.15; // 15% discount
            case "Premium":
                return 0.10; // 10% discount
            case "Standard":
                return 0.05; // 5% discount
            case "Basic":
                return 0.0; // No discount
            default:
                return 0.0;
        }
    }
    
    public double getBulkDiscountRate(double amount) {
        if (amount >= 1000) {
            return 0.10; // 10% discount
        } else if (amount >= 500) {
            return 0.05; // 5% discount
        } else if (amount >= 100) {
            return 0.02; // 2% discount
        } else {
            return 0.0; // No discount
        }
    }
    
    public double getSeasonalDiscountRate() {
        int currentMonth = LocalDateTime.now().getMonthValue();
        
        if (currentMonth == 12) { // December
            return 0.08; // 8% holiday discount
        } else if (currentMonth >= 6 && currentMonth <= 8) { // Summer
            return 0.05; // 5% summer discount
        }
        
        return 0.0; // No seasonal discount
    }
}

// ✅ GOOD: Discount Value Object
public class Discount {
    private final String id;
    private final String name;
    private final String type;
    private final double value;
    private final String description;
    
    public Discount(String id, String name, String type, double value, String description) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.value = value;
        this.description = description;
    }
    
    public String getId() {
        return id;
    }
    
    public String getName() {
        return name;
    }
    
    public String getType() {
        return type;
    }
    
    public double getValue() {
        return value;
    }
    
    public String getDescription() {
        return description;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Discount discount = (Discount) obj;
        return Objects.equals(id, discount.id);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
    
    @Override
    public String toString() {
        return String.format("Discount{id='%s', name='%s', type='%s', value=%.2f, description='%s'}",
                id, name, type, value, description);
    }
}

// ✅ GOOD: Address Value Object
public class Address {
    private final String street;
    private final String city;
    private final String state;
    private final String country;
    private final String postalCode;
    
    public Address(String street, String city, String state, String country, String postalCode) {
        if (street == null || street.trim().isEmpty()) {
            throw new IllegalArgumentException("Street cannot be null or empty");
        }
        if (city == null || city.trim().isEmpty()) {
            throw new IllegalArgumentException("City cannot be null or empty");
        }
        if (country == null || country.trim().isEmpty()) {
            throw new IllegalArgumentException("Country cannot be null or empty");
        }
        
        this.street = street.trim();
        this.city = city.trim();
        this.state = state != null ? state.trim() : "";
        this.country = country.trim();
        this.postalCode = postalCode != null ? postalCode.trim() : "";
    }
    
    public String getStreet() {
        return street;
    }
    
    public String getCity() {
        return city;
    }
    
    public String getState() {
        return state;
    }
    
    public String getCountry() {
        return country;
    }
    
    public String getPostalCode() {
        return postalCode;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Address address = (Address) obj;
        return Objects.equals(street, address.street) &&
               Objects.equals(city, address.city) &&
               Objects.equals(state, address.state) &&
               Objects.equals(country, address.country) &&
               Objects.equals(postalCode, address.postalCode);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(street, city, state, country, postalCode);
    }
    
    @Override
    public String toString() {
        return String.format("%s, %s, %s %s, %s", street, city, state, postalCode, country);
    }
}

// ❌ BAD: Anemic Domain Service
class BadPricingService {
    // ❌ Only data, no behavior
    private double taxRate;
    private double shippingRate;
    private double discountRate;
    
    public BadPricingService(double taxRate, double shippingRate, double discountRate) {
        this.taxRate = taxRate;
        this.discountRate = discountRate;
        this.shippingRate = shippingRate;
    }
    
    // ❌ Business logic in external service
    public double calculateTotal(double orderAmount, String customerType, String country) {
        // Business logic should be in the domain service
        double discount = calculateDiscount(orderAmount, customerType);
        double tax = calculateTax(orderAmount - discount, country);
        double shipping = calculateShipping(country);
        
        return orderAmount - discount + tax + shipping;
    }
    
    private double calculateDiscount(double amount, String customerType) {
        // Business logic scattered
        switch (customerType) {
            case "VIP": return amount * 0.15;
            case "Premium": return amount * 0.10;
            default: return amount * 0.05;
        }
    }
    
    private double calculateTax(double amount, String country) {
        // Business logic scattered
        if ("US".equals(country)) {
            return amount * 0.08;
        }
        return 0;
    }
    
    private double calculateShipping(String country) {
        // Business logic scattered
        if ("US".equals(country)) {
            return 5.99;
        }
        return 15.99;
    }
}

// ✅ GOOD: Pricing Service Factory
public class PricingServiceFactory {
    public static PricingService createDefaultPricingService() {
        TaxCalculator taxCalculator = new TaxCalculator();
        ShippingCalculator shippingCalculator = new ShippingCalculator();
        DiscountRuleRepository discountRuleRepository = new DiscountRuleRepository();
        
        return new PricingService(taxCalculator, shippingCalculator, discountRuleRepository);
    }
    
    public static PricingService createPricingServiceWithCustomRules(DiscountRuleRepository customRules) {
        TaxCalculator taxCalculator = new TaxCalculator();
        ShippingCalculator shippingCalculator = new ShippingCalculator();
        
        return new PricingService(taxCalculator, shippingCalculator, customRules);
    }
}

// Example usage
public class PricingServiceExample {
    public static void main(String[] args) {
        // Create pricing service
        PricingService pricingService = PricingServiceFactory.createDefaultPricingService();
        
        // Create order
        CustomerId customerId = CustomerId.of("customer-123");
        Order order = new Order(OrderId.generate(), customerId);
        order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
        order.addItem(ProductId.of("product-2"), 1, Money.of(25.50, "USD"));
        order.confirm();
        
        // Create customer
        Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
        customer.activate();
        
        // Create shipping address
        Address address = new Address("123 Main St", "Anytown", "CA", "US", "12345");
        
        // Calculate order total
        Money total = pricingService.calculateOrderTotal(order, customer, address);
        System.out.println("Order total: " + total);
        
        // Calculate discount amount
        Money discount = pricingService.calculateDiscountAmount(order, customer);
        System.out.println("Discount amount: " + discount);
        
        // Get available discounts
        List<Discount> discounts = pricingService.getAvailableDiscounts(order, customer);
        System.out.println("Available discounts:");
        for (Discount discountItem : discounts) {
            System.out.println("  " + discountItem);
        }
    }
}
```

## Key Concepts Demonstrated

### Domain Services and Domain Service Design Principles

#### 1. **Stateless Services**
- ✅ PricingService has no instance variables for state
- ✅ All operations are pure functions
- ✅ Same inputs always produce same outputs

#### 2. **Complex Business Logic**
- ✅ PricingService handles complex pricing calculations
- ✅ Business logic is encapsulated within the service
- ✅ Service coordinates multiple domain objects

#### 3. **Service Composition**
- ✅ PricingService uses other domain services
- ✅ TaxCalculator, ShippingCalculator, DiscountRuleRepository
- ✅ Service interactions are well-defined

#### 4. **Business Operations**
- ✅ calculateOrderTotal() is the main business operation
- ✅ calculateDiscountAmount() provides discount information
- ✅ getAvailableDiscounts() lists all applicable discounts

### Pricing Service Design Principles

#### **Stateless Design**
- ✅ PricingService has no instance variables for state
- ✅ All operations are pure functions
- ✅ Thread-safe by design

#### **Service Composition**
- ✅ PricingService uses other domain services
- ✅ Dependencies are injected through constructor
- ✅ Service interactions are well-defined

#### **Business Logic Encapsulation**
- ✅ Complex pricing logic is encapsulated
- ✅ Business rules are centralized
- ✅ Service provides clear business operations

#### **Domain Service Interface**
- ✅ Clear public interface for business operations
- ✅ Private methods for complex calculations
- ✅ Service is focused on pricing domain

### Java Benefits for Domain Services
- **Strong Typing**: Compile-time type checking
- **Interface Segregation**: Clear contracts for dependencies
- **Dependency Injection**: Constructor injection for dependencies
- **Method Chaining**: Fluent interfaces for operations
- **Error Handling**: Clear exception messages for business rules
- **Collections**: Rich collection framework for managing data

### Common Anti-Patterns to Avoid

#### **Anemic Domain Service**
- ❌ Service contains only data
- ❌ Business logic in external services
- ❌ No encapsulation of business rules

#### **God Service**
- ❌ Single service with too many responsibilities
- ❌ Hard to understand and maintain
- ❌ Violates Single Responsibility Principle

#### **Stateful Services**
- ❌ Services with instance variables for state
- ❌ Thread safety issues
- ❌ Hard to test and maintain

## Related Concepts

- [Order Entity](./03-order-entity.md) - Entity used by Pricing Service
- [Customer Entity](./01-customer-entity.md) - Entity used by Pricing Service
- [EmailAddress Value Object](./04-email-address-value-object.md) - Value object example
- [Domain Services and Domain Service Design Principles](../../1-introduction-to-the-domain.md#domain-services-and-domain-service-design-principles) - Domain service concepts

/*
 * Navigation:
 * Previous: 04-email-address-value-object.md
 * Next: 06-customer-module.md
 *
 * Back to: [Domain Services and Domain Service Design Principles](../../1-introduction-to-the-domain.md#domain-services-and-domain-service-design-principles)
 */
