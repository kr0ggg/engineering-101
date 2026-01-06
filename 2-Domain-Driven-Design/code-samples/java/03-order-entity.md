# Order Entity - Java Example

**Section**: [Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation)

**Navigation**: [← Previous: Customer Entity](./01-customer-entity.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - Order Entity with Business Logic Encapsulation
// File: 2-Domain-Driven-Design/code-samples/java/03-order-entity.java

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

// ✅ GOOD: Rich Domain Model with Behavior
public enum OrderStatus {
    DRAFT("Draft"),
    CONFIRMED("Confirmed"),
    SHIPPED("Shipped"),
    DELIVERED("Delivered"),
    CANCELLED("Cancelled");
    
    private final String value;
    
    OrderStatus(String value) {
        this.value = value;
    }
    
    public String getValue() {
        return value;
    }
}

// ✅ GOOD: Value Objects for Identity
public class OrderId {
    private final String value;
    
    private OrderId(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Order ID cannot be null or empty");
        }
        this.value = value.trim();
    }
    
    public static OrderId generate() {
        return new OrderId(UUID.randomUUID().toString());
    }
    
    public static OrderId of(String value) {
        return new OrderId(value);
    }
    
    public String getValue() {
        return value;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        OrderId orderId = (OrderId) obj;
        return Objects.equals(value, orderId.value);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(value);
    }
    
    @Override
    public String toString() {
        return value;
    }
}

public class CustomerId {
    private final String value;
    
    private CustomerId(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Customer ID cannot be null or empty");
        }
        this.value = value.trim();
    }
    
    public static CustomerId of(String value) {
        return new CustomerId(value);
    }
    
    public String getValue() {
        return value;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        CustomerId customerId = (CustomerId) obj;
        return Objects.equals(value, customerId.value);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(value);
    }
    
    @Override
    public String toString() {
        return value;
    }
}

public class ProductId {
    private final String value;
    
    private ProductId(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Product ID cannot be null or empty");
        }
        this.value = value.trim();
    }
    
    public static ProductId of(String value) {
        return new ProductId(value);
    }
    
    public String getValue() {
        return value;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        ProductId productId = (ProductId) obj;
        return Objects.equals(value, productId.value);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(value);
    }
    
    @Override
    public String toString() {
        return value;
    }
}

// ✅ GOOD: Value Object for Money
public class Money {
    private final double amount;
    private final String currency;
    
    private Money(double amount, String currency) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        if (currency == null || currency.trim().isEmpty()) {
            throw new IllegalArgumentException("Currency cannot be null or empty");
        }
        this.amount = amount;
        this.currency = currency.trim();
    }
    
    public static Money of(double amount, String currency) {
        return new Money(amount, currency);
    }
    
    public static Money zero(String currency) {
        return new Money(0.0, currency);
    }
    
    public Money add(Money other) {
        if (!this.currency.equals(other.currency)) {
            throw new IllegalArgumentException("Cannot add different currencies");
        }
        return new Money(this.amount + other.amount, this.currency);
    }
    
    public Money subtract(Money other) {
        if (!this.currency.equals(other.currency)) {
            throw new IllegalArgumentException("Cannot subtract different currencies");
        }
        return new Money(this.amount - other.amount, this.currency);
    }
    
    public Money multiply(double factor) {
        if (factor < 0) {
            throw new IllegalArgumentException("Factor cannot be negative");
        }
        return new Money(this.amount * factor, this.currency);
    }
    
    public double getAmount() {
        return amount;
    }
    
    public String getCurrency() {
        return currency;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Money money = (Money) obj;
        return Double.compare(money.amount, amount) == 0 &&
               Objects.equals(currency, money.currency);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(amount, currency);
    }
    
    @Override
    public String toString() {
        return String.format("%s %.2f", currency, amount);
    }
}

// ✅ GOOD: Value Object for Order Item
public class OrderItem {
    private final ProductId productId;
    private final int quantity;
    private final Money unitPrice;
    
    public OrderItem(ProductId productId, int quantity, Money unitPrice) {
        if (productId == null) {
            throw new IllegalArgumentException("Product ID cannot be null");
        }
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be positive");
        }
        if (unitPrice == null) {
            throw new IllegalArgumentException("Unit price cannot be null");
        }
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }
    
    public ProductId getProductId() {
        return productId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public Money getUnitPrice() {
        return unitPrice;
    }
    
    public Money getTotalPrice() {
        return unitPrice.multiply(quantity);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        OrderItem orderItem = (OrderItem) obj;
        return quantity == orderItem.quantity &&
               Objects.equals(productId, orderItem.productId) &&
               Objects.equals(unitPrice, orderItem.unitPrice);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(productId, quantity, unitPrice);
    }
    
    @Override
    public String toString() {
        return String.format("OrderItem{productId=%s, quantity=%d, unitPrice=%s}",
                productId, quantity, unitPrice);
    }
}

// ✅ GOOD: Domain Entity with Rich Behavior
public class Order {
    private final OrderId id;
    private final CustomerId customerId;
    private final LocalDateTime createdAt;
    private final List<OrderItem> items;
    private OrderStatus status;
    private LocalDateTime confirmedAt;
    private LocalDateTime shippedAt;
    
    public Order(OrderId id, CustomerId customerId) {
        this(id, customerId, LocalDateTime.now());
    }
    
    public Order(OrderId id, CustomerId customerId, LocalDateTime createdAt) {
        if (id == null) {
            throw new IllegalArgumentException("Order ID cannot be null");
        }
        if (customerId == null) {
            throw new IllegalArgumentException("Customer ID cannot be null");
        }
        if (createdAt == null) {
            throw new IllegalArgumentException("Created at cannot be null");
        }
        
        this.id = id;
        this.customerId = customerId;
        this.createdAt = createdAt;
        this.items = new ArrayList<>();
        this.status = OrderStatus.DRAFT;
    }
    
    // ✅ Identity properties
    public OrderId getId() {
        return id;
    }
    
    public CustomerId getCustomerId() {
        return customerId;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public OrderStatus getStatus() {
        return status;
    }
    
    public List<OrderItem> getItems() {
        return new ArrayList<>(items); // Return copy to maintain encapsulation
    }
    
    public int getItemCount() {
        return items.size();
    }
    
    public Money getTotalAmount() {
        if (items.isEmpty()) {
            return Money.zero("USD");
        }
        
        Money total = items.get(0).getTotalPrice();
        for (int i = 1; i < items.size(); i++) {
            total = total.add(items.get(i).getTotalPrice());
        }
        return total;
    }
    
    // ✅ Business Logic Encapsulation
    public void addItem(ProductId productId, int quantity, Money unitPrice) {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException("Cannot modify confirmed order");
        }
        
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be positive");
        }
        
        // Business rule: Check if item already exists
        int existingItemIndex = findItemIndex(productId);
        
        if (existingItemIndex >= 0) {
            // Update existing item quantity
            OrderItem existingItem = items.get(existingItemIndex);
            int newQuantity = existingItem.getQuantity() + quantity;
            OrderItem updatedItem = new OrderItem(productId, newQuantity, unitPrice);
            items.set(existingItemIndex, updatedItem);
        } else {
            // Add new item
            OrderItem newItem = new OrderItem(productId, quantity, unitPrice);
            items.add(newItem);
        }
    }
    
    public void removeItem(ProductId productId) {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException("Cannot modify confirmed order");
        }
        
        int itemIndex = findItemIndex(productId);
        if (itemIndex >= 0) {
            items.remove(itemIndex);
        } else {
            throw new IllegalArgumentException("Item not found in order");
        }
    }
    
    public void updateItemQuantity(ProductId productId, int newQuantity) {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException("Cannot modify confirmed order");
        }
        
        if (newQuantity <= 0) {
            throw new IllegalArgumentException("Quantity must be positive");
        }
        
        int itemIndex = findItemIndex(productId);
        if (itemIndex >= 0) {
            OrderItem existingItem = items.get(itemIndex);
            OrderItem updatedItem = new OrderItem(productId, newQuantity, existingItem.getUnitPrice());
            items.set(itemIndex, updatedItem);
        } else {
            throw new IllegalArgumentException("Item not found in order");
        }
    }
    
    public void confirm() {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException("Order is not in draft status");
        }
        
        if (items.isEmpty()) {
            throw new IllegalStateException("Cannot confirm empty order");
        }
        
        // Business rule: Minimum order amount
        if (getTotalAmount().getAmount() < 10.0) {
            throw new IllegalStateException("Order amount must be at least $10.00");
        }
        
        this.status = OrderStatus.CONFIRMED;
        this.confirmedAt = LocalDateTime.now();
    }
    
    public void ship() {
        if (status != OrderStatus.CONFIRMED) {
            throw new IllegalStateException("Order must be confirmed before shipping");
        }
        
        this.status = OrderStatus.SHIPPED;
        this.shippedAt = LocalDateTime.now();
    }
    
    public void deliver() {
        if (status != OrderStatus.SHIPPED) {
            throw new IllegalStateException("Order must be shipped before delivery");
        }
        
        this.status = OrderStatus.DELIVERED;
    }
    
    public void cancel() {
        if (status == OrderStatus.SHIPPED || status == OrderStatus.DELIVERED) {
            throw new IllegalStateException("Cannot cancel shipped or delivered order");
        }
        
        this.status = OrderStatus.CANCELLED;
    }
    
    // ✅ Business Rules as Methods
    public boolean canBeModified() {
        return status == OrderStatus.DRAFT;
    }
    
    public boolean canBeConfirmed() {
        return status == OrderStatus.DRAFT && 
               !items.isEmpty() && 
               getTotalAmount().getAmount() >= 10.0;
    }
    
    public boolean canBeShipped() {
        return status == OrderStatus.CONFIRMED;
    }
    
    public boolean canBeDelivered() {
        return status == OrderStatus.SHIPPED;
    }
    
    public boolean canBeCancelled() {
        return status == OrderStatus.DRAFT || status == OrderStatus.CONFIRMED;
    }
    
    // ✅ Helper methods
    private int findItemIndex(ProductId productId) {
        for (int i = 0; i < items.size(); i++) {
            if (items.get(i).getProductId().equals(productId)) {
                return i;
            }
        }
        return -1;
    }
    
    public OrderItem getItemByProductId(ProductId productId) {
        int itemIndex = findItemIndex(productId);
        return itemIndex >= 0 ? items.get(itemIndex) : null;
    }
    
    public boolean hasItem(ProductId productId) {
        return findItemIndex(productId) >= 0;
    }
    
    // ✅ Domain Events (simplified)
    public List<String> getDomainEvents() {
        List<String> events = new ArrayList<>();
        if (status == OrderStatus.CONFIRMED) {
            events.add("OrderConfirmed");
        }
        if (status == OrderStatus.SHIPPED) {
            events.add("OrderShipped");
        }
        if (status == OrderStatus.DELIVERED) {
            events.add("OrderDelivered");
        }
        if (status == OrderStatus.CANCELLED) {
            events.add("OrderCancelled");
        }
        return events;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Order order = (Order) obj;
        return Objects.equals(id, order.id);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
    
    @Override
    public String toString() {
        return String.format("Order{id=%s, customerId=%s, status=%s, items=%d, total=%s}",
                id, customerId, status.getValue(), items.size(), getTotalAmount());
    }
}

// ❌ BAD: Anemic Domain Model
class BadOrder {
    // ❌ Only data, no behavior
    public String id;
    public String customerId;
    public List<Object> items;
    public String status;
    public double totalAmount;
    public LocalDateTime createdAt;
    
    public BadOrder(String id, String customerId) {
        this.id = id;
        this.customerId = customerId;
        this.items = new ArrayList<>();
        this.status = "Draft";
        this.totalAmount = 0.0;
        this.createdAt = LocalDateTime.now();
    }
    
    // ❌ Business logic in external service
    public void addItem(String productId, int quantity, double unitPrice) {
        // Business logic should be in the domain object
        if (!"Draft".equals(status)) {
            throw new IllegalArgumentException("Cannot modify confirmed order");
        }
        // ... rest of logic
    }
}

// ✅ GOOD: Domain Service for Complex Business Logic
class OrderPricingService {
    // ✅ Stateless service - no instance variables
    public Money calculateOrderTotal(Order order, Customer customer, Address shippingAddress) {
        if (!customer.isActive()) {
            throw new IllegalArgumentException("Cannot calculate pricing for inactive customer");
        }
        
        // ✅ Pure function - same inputs always produce same outputs
        Money total = order.getTotalAmount();
        total = applyCustomerDiscount(total, customer);
        total = applyBulkDiscount(total, order);
        
        Money tax = calculateTax(total, shippingAddress);
        Money shipping = calculateShipping(order, shippingAddress);
        
        return total.add(tax).add(shipping);
    }
    
    // ✅ Private methods for complex calculations
    private Money applyCustomerDiscount(Money total, Customer customer) {
        double discountRate = getCustomerDiscountRate(customer.getCustomerType());
        Money discountAmount = total.multiply(discountRate);
        return total.subtract(discountAmount);
    }
    
    private double getCustomerDiscountRate(String customerType) {
        switch (customerType) {
            case "VIP": return 0.15;
            case "Premium": return 0.10;
            case "Standard": return 0.05;
            default: return 0.05;
        }
    }
    
    private Money applyBulkDiscount(Money total, Order order) {
        if (total.getAmount() >= 1000) {
            return total.multiply(0.10);
        } else if (total.getAmount() >= 500) {
            return total.multiply(0.05);
        } else if (total.getAmount() >= 100) {
            return total.multiply(0.02);
        }
        return Money.zero(total.getCurrency());
    }
    
    private Money calculateTax(Money amount, Address address) {
        // Simplified tax calculation
        if ("US".equals(address.getCountry())) {
            return amount.multiply(0.08);
        }
        return Money.zero(amount.getCurrency());
    }
    
    private Money calculateShipping(Order order, Address address) {
        // Simplified shipping calculation
        if ("US".equals(address.getCountry())) {
            return Money.of(5.99, "USD");
        }
        return Money.of(15.99, "USD");
    }
}

// ✅ GOOD: Factory for Complex Object Creation
class OrderFactory {
    public static Order createDraftOrder(CustomerId customerId) {
        OrderId orderId = OrderId.generate();
        return new Order(orderId, customerId);
    }
    
    public static Order createOrderFromCart(CustomerId customerId, List<CartItem> cartItems) {
        Order order = createDraftOrder(customerId);
        
        for (CartItem cartItem : cartItems) {
            ProductId productId = ProductId.of(cartItem.getProductId());
            Money unitPrice = Money.of(cartItem.getUnitPrice(), "USD");
            order.addItem(productId, cartItem.getQuantity(), unitPrice);
        }
        
        return order;
    }
}

// ✅ GOOD: Specification Pattern for Complex Business Rules
class OrderSpecification {
    public boolean canBeConfirmed(Order order) {
        return order.getStatus() == OrderStatus.DRAFT &&
               !order.getItems().isEmpty() &&
               order.getTotalAmount().getAmount() >= 10.0 &&
               hasValidItems(order);
    }
    
    public boolean canBeShipped(Order order) {
        return order.getStatus() == OrderStatus.CONFIRMED &&
               hasShippingAddress(order) &&
               allItemsInStock(order);
    }
    
    private boolean hasValidItems(Order order) {
        return order.getItems().stream()
                .allMatch(item -> item.getQuantity() > 0);
    }
    
    private boolean hasShippingAddress(Order order) {
        // Simplified - would check actual address
        return true;
    }
    
    private boolean allItemsInStock(Order order) {
        // Simplified - would check inventory
        return true;
    }
}

// Example usage
public class OrderExample {
    public static void main(String[] args) {
        // Create order
        CustomerId customerId = CustomerId.of("customer-123");
        Order order = OrderFactory.createDraftOrder(customerId);
        
        // Add items
        ProductId product1 = ProductId.of("product-1");
        ProductId product2 = ProductId.of("product-2");
        
        order.addItem(product1, 2, Money.of(15.99, "USD"));
        order.addItem(product2, 1, Money.of(25.50, "USD"));
        
        System.out.println("Order created: " + order);
        System.out.println("Total amount: " + order.getTotalAmount());
        System.out.println("Can be confirmed: " + order.canBeConfirmed());
        
        // Confirm order
        order.confirm();
        System.out.println("Order confirmed: " + order);
        System.out.println("Can be shipped: " + order.canBeShipped());
        
        // Ship order
        order.ship();
        System.out.println("Order shipped: " + order);
        System.out.println("Can be delivered: " + order.canBeDelivered());
        
        // Deliver order
        order.deliver();
        System.out.println("Order delivered: " + order);
    }
}
```

## Key Concepts Demonstrated

### Business Logic Encapsulation

#### 1. **Rich Domain Models**
- ✅ Domain objects contain both data and behavior
- ✅ Business logic is encapsulated within the objects that own the data
- ✅ Methods express business operations clearly

#### 2. **Business Rules as Methods**
- ✅ Business rules are expressed as methods on domain objects
- ✅ Validation happens at the domain boundary
- ✅ Clear error messages for business rule violations

#### 3. **State Management**
- ✅ Order status is managed through business operations
- ✅ State transitions are controlled by business rules
- ✅ Invalid state transitions are prevented

#### 4. **Domain Events**
- ✅ Significant business events are captured
- ✅ Events can be used for integration and notifications
- ✅ Domain events maintain consistency

### Order Entity Design Principles

#### **Identity Management**
- ✅ Order has a unique identity (OrderId)
- ✅ Identity is immutable and generated
- ✅ Identity distinguishes orders from each other

#### **Business Logic Encapsulation**
- ✅ Order contains all business rules for order management
- ✅ Operations like addItem, confirm, ship are methods
- ✅ Business rules prevent invalid operations

#### **State Management**
- ✅ Order status is managed through business operations
- ✅ State transitions follow business rules
- ✅ Invalid transitions are prevented

#### **Value Objects**
- ✅ OrderId, CustomerId, ProductId are value objects
- ✅ Money is a value object with business operations
- ✅ OrderItem is a value object representing order line items

### Java Benefits for Domain Modeling
- **Strong Typing**: Compile-time type checking
- **Immutability**: Final fields and immutable value objects
- **Encapsulation**: Private fields with public methods
- **Method Chaining**: Fluent interfaces for operations
- **Error Handling**: Clear exception messages for business rules
- **Collections**: Rich collection framework for managing items

### Common Anti-Patterns to Avoid

#### **Anemic Domain Model**
- ❌ Domain objects contain only data
- ❌ Business logic in external services
- ❌ No encapsulation of business rules

#### **Primitive Obsession**
- ❌ Using primitives instead of domain types
- ❌ No type safety for business concepts
- ❌ Scattered validation logic

#### **God Object**
- ❌ Single object with too many responsibilities
- ❌ Hard to understand and maintain
- ❌ Violates Single Responsibility Principle

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Basic entity design
- [Money Value Object](./02-money-value-object.md) - Value object example
- [EmailAddress Value Object](./04-email-address-value-object.md) - Validation example
- [Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation) - Business logic concepts

/*
 * Navigation:
 * Previous: 01-customer-entity.md
 * Next: 04-email-address-value-object.md
 *
 * Back to: [Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation)
 */
