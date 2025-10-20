# Domain Modeling Best Practices - Java Example

**Section**: [Best Practices for Domain Modeling](../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling)

**Navigation**: [← Previous: Testing Best Practices](./12-testing-best-practices.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - Domain Modeling Best Practices
// File: 2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices.java

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

// ✅ GOOD: Domain Modeling Best Practices
@DisplayName("Domain Modeling Best Practices")
class DomainModelingBestPractices {
    
    // ✅ GOOD: Rich Domain Models with Behavior
    public static class Order {
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
    
    // ✅ GOOD: Immutable Value Objects
    public static class Money {
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
    
    // ✅ GOOD: Self-Validating Value Objects
    public static class EmailAddress {
        private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        );
        
        private final String value;
        
        private EmailAddress(String value) {
            if (value == null || value.trim().isEmpty()) {
                throw new IllegalArgumentException("Email address cannot be null or empty");
            }
            
            String trimmedValue = value.trim();
            if (!isValidEmail(trimmedValue)) {
                throw new IllegalArgumentException("Invalid email address: " + trimmedValue);
            }
            
            this.value = trimmedValue.toLowerCase(); // Normalize to lowercase
        }
        
        public static EmailAddress of(String value) {
            return new EmailAddress(value);
        }
        
        public String getValue() {
            return value;
        }
        
        // ✅ Self-Validation
        private boolean isValidEmail(String email) {
            return EMAIL_PATTERN.matcher(email).matches();
        }
        
        // ✅ Business Operations
        public String getDomain() {
            int atIndex = value.indexOf('@');
            if (atIndex == -1) {
                throw new IllegalStateException("Invalid email format");
            }
            return value.substring(atIndex + 1);
        }
        
        public String getLocalPart() {
            int atIndex = value.indexOf('@');
            if (atIndex == -1) {
                throw new IllegalStateException("Invalid email format");
            }
            return value.substring(0, atIndex);
        }
        
        public boolean isCorporateEmail() {
            String domain = getDomain();
            return domain.endsWith(".com") || 
                   domain.endsWith(".org") || 
                   domain.endsWith(".net");
        }
        
        public boolean isEducationalEmail() {
            String domain = getDomain();
            return domain.endsWith(".edu");
        }
        
        public boolean isGovernmentEmail() {
            String domain = getDomain();
            return domain.endsWith(".gov");
        }
        
        @Override
        public boolean equals(Object obj) {
            if (this == obj) return true;
            if (obj == null || getClass() != obj.getClass()) return false;
            EmailAddress that = (EmailAddress) obj;
            return Objects.equals(value, that.value);
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
    
    // ✅ GOOD: Domain Services for Complex Business Logic
    public static class PricingService {
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
    }
    
    // ✅ GOOD: Factory for Complex Object Creation
    public static class OrderFactory {
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
    public static class OrderSpecification {
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
    
    // ✅ GOOD: Module Organization with Clear Boundaries
    public static class CustomerModule {
        
        // ✅ Domain Entities
        public static class Customer {
            private final CustomerId id;
            private String name;
            private EmailAddress email;
            private CustomerStatus status;
            private LocalDateTime createdAt;
            private LocalDateTime lastActivity;
            private int ordersCount;
            private Money totalSpent;
            
            public Customer(CustomerId id, String name, EmailAddress email) {
                if (id == null) {
                    throw new IllegalArgumentException("Customer ID cannot be null");
                }
                if (name == null || name.trim().isEmpty()) {
                    throw new IllegalArgumentException("Name cannot be null or empty");
                }
                if (email == null) {
                    throw new IllegalArgumentException("Email cannot be null");
                }
                
                this.id = id;
                this.name = name.trim();
                this.email = email;
                this.status = CustomerStatus.PENDING;
                this.createdAt = LocalDateTime.now();
                this.ordersCount = 0;
                this.totalSpent = Money.zero("USD");
            }
            
            // ✅ Business Operations
            public void activate() {
                if (status == CustomerStatus.SUSPENDED) {
                    throw new IllegalStateException("Cannot activate suspended customer");
                }
                this.status = CustomerStatus.ACTIVE;
                this.lastActivity = LocalDateTime.now();
            }
            
            public void deactivate() {
                this.status = CustomerStatus.INACTIVE;
                this.lastActivity = LocalDateTime.now();
            }
            
            public void suspend() {
                this.status = CustomerStatus.SUSPENDED;
                this.lastActivity = LocalDateTime.now();
            }
            
            public void updateEmail(EmailAddress newEmail) {
                if (status == CustomerStatus.SUSPENDED) {
                    throw new IllegalStateException("Cannot update email for suspended customer");
                }
                this.email = newEmail;
                this.lastActivity = LocalDateTime.now();
            }
            
            public void updateName(String newName) {
                if (newName == null || newName.trim().isEmpty()) {
                    throw new IllegalArgumentException("Name cannot be null or empty");
                }
                this.name = newName.trim();
                this.lastActivity = LocalDateTime.now();
            }
            
            public void recordOrder(Money orderAmount) {
                if (status != CustomerStatus.ACTIVE) {
                    throw new IllegalStateException("Only active customers can place orders");
                }
                this.ordersCount++;
                this.totalSpent = this.totalSpent.add(orderAmount);
                this.lastActivity = LocalDateTime.now();
            }
            
            // ✅ Business Rules
            public boolean isActive() {
                return status == CustomerStatus.ACTIVE;
            }
            
            public boolean canPlaceOrders() {
                return status == CustomerStatus.ACTIVE;
            }
            
            public boolean isVip() {
                return totalSpent.getAmount() >= 1000;
            }
            
            public boolean isPremium() {
                return totalSpent.getAmount() >= 500;
            }
            
            public String getCustomerType() {
                if (isVip()) {
                    return "VIP";
                } else if (isPremium()) {
                    return "Premium";
                } else {
                    return "Standard";
                }
            }
            
            // Getters
            public CustomerId getId() {
                return id;
            }
            
            public String getName() {
                return name;
            }
            
            public EmailAddress getEmail() {
                return email;
            }
            
            public CustomerStatus getStatus() {
                return status;
            }
            
            public LocalDateTime getCreatedAt() {
                return createdAt;
            }
            
            public LocalDateTime getLastActivity() {
                return lastActivity;
            }
            
            public int getOrdersCount() {
                return ordersCount;
            }
            
            public Money getTotalSpent() {
                return totalSpent;
            }
            
            @Override
            public boolean equals(Object obj) {
                if (this == obj) return true;
                if (obj == null || getClass() != obj.getClass()) return false;
                Customer customer = (Customer) obj;
                return Objects.equals(id, customer.id);
            }
            
            @Override
            public int hashCode() {
                return Objects.hash(id);
            }
            
            @Override
            public String toString() {
                return String.format("Customer{id=%s, name='%s', email=%s, status=%s}",
                        id, name, email, status);
            }
        }
        
        // ✅ Domain Services
        public static class CustomerService {
            private final CustomerRepository customerRepository;
            private final EmailService emailService;
            
            public CustomerService(CustomerRepository customerRepository, EmailService emailService) {
                this.customerRepository = customerRepository;
                this.emailService = emailService;
            }
            
            public Customer registerCustomer(String name, String emailString) {
                // ✅ Validate input and create value objects
                if (name == null || name.trim().isEmpty()) {
                    throw new IllegalArgumentException("Name cannot be empty");
                }
                
                EmailAddress email = EmailAddress.of(emailString);
                
                // ✅ Check if customer already exists
                Optional<Customer> existingCustomer = customerRepository.findByEmail(email);
                if (existingCustomer.isPresent()) {
                    throw new IllegalArgumentException("Customer with this email already exists");
                }
                
                // ✅ Create new customer
                CustomerId customerId = CustomerId.generate();
                Customer customer = new Customer(customerId, name, email);
                
                // ✅ Save customer
                customerRepository.save(customer);
                
                // ✅ Send welcome email
                emailService.sendWelcomeEmail(customer);
                
                return customer;
            }
            
            public void updateCustomerEmail(String customerIdString, String newEmailString) {
                CustomerId customerId = CustomerId.of(customerIdString);
                EmailAddress newEmail = EmailAddress.of(newEmailString);
                
                // ✅ Find customer
                Optional<Customer> customerOpt = customerRepository.findById(customerId);
                if (customerOpt.isEmpty()) {
                    throw new IllegalArgumentException("Customer not found");
                }
                
                Customer customer = customerOpt.get();
                
                // ✅ Check if email is already in use
                Optional<Customer> existingCustomer = customerRepository.findByEmail(newEmail);
                if (existingCustomer.isPresent() && !existingCustomer.get().getId().equals(customerId)) {
                    throw new IllegalArgumentException("Email already in use");
                }
                
                // ✅ Update email
                customer.updateEmail(newEmail);
                
                // ✅ Save changes
                customerRepository.save(customer);
                
                // ✅ Send email change notification
                emailService.sendEmailChangeNotification(customer);
            }
        }
        
        // ✅ Repository Interfaces
        public interface CustomerRepository {
            void save(Customer customer);
            Optional<Customer> findById(CustomerId id);
            Optional<Customer> findByEmail(EmailAddress email);
            List<Customer> findByStatus(CustomerStatus status);
            List<Customer> findVipCustomers();
            List<Customer> findByCustomerType(String customerType);
            void delete(CustomerId id);
        }
        
        // ✅ Service Interfaces
        public interface EmailService {
            void sendWelcomeEmail(Customer customer);
            void sendEmailChangeNotification(Customer customer);
            void sendSuspensionNotification(Customer customer, String reason);
            void sendActivationNotification(Customer customer);
            void sendEmail(EmailAddress email, String subject, String body);
        }
    }
}

// Example usage
public class DomainModelingBestPracticesExample {
    public static void main(String[] args) {
        System.out.println("Domain Modeling Best Practices:");
        System.out.println("1. ✅ Rich Domain Models with Behavior");
        System.out.println("2. ✅ Immutable Value Objects");
        System.out.println("3. ✅ Self-Validating Value Objects");
        System.out.println("4. ✅ Domain Services for Complex Business Logic");
        System.out.println("5. ✅ Factory for Complex Object Creation");
        System.out.println("6. ✅ Specification Pattern for Complex Business Rules");
        System.out.println("7. ✅ Module Organization with Clear Boundaries");
        System.out.println("8. ✅ Repository Pattern for Data Access");
        System.out.println("9. ✅ Service Interfaces for External Dependencies");
        System.out.println("10. ✅ Business Rules Encapsulated in Domain Objects");
    }
}
```

## Key Concepts Demonstrated

### Best Practices for Domain Modeling

#### 1. **Rich Domain Models with Behavior**
- ✅ Domain objects contain both data and behavior
- ✅ Business logic is encapsulated within the objects that own the data
- ✅ Methods express business operations clearly

#### 2. **Immutable Value Objects**
- ✅ Value objects are immutable once created
- ✅ All fields are final
- ✅ No setter methods
- ✅ Thread-safe by design

#### 3. **Self-Validating Value Objects**
- ✅ Value objects validate themselves during construction
- ✅ Invalid values are rejected immediately
- ✅ Validation logic is encapsulated within the value object

#### 4. **Domain Services for Complex Business Logic**
- ✅ Domain services handle complex business logic
- ✅ Services are stateless
- ✅ Services coordinate multiple domain objects

#### 5. **Factory for Complex Object Creation**
- ✅ Factories handle complex object creation
- ✅ Factories encapsulate creation logic
- ✅ Factories provide clear interfaces

#### 6. **Specification Pattern for Complex Business Rules**
- ✅ Specifications encapsulate complex business rules
- ✅ Specifications are reusable
- ✅ Specifications are testable

#### 7. **Module Organization with Clear Boundaries**
- ✅ Modules contain related functionality
- ✅ Clear separation between modules
- ✅ Modules provide cohesive functionality

#### 8. **Repository Pattern for Data Access**
- ✅ Repositories abstract data access
- ✅ Repositories provide clear interfaces
- ✅ Repositories are testable

#### 9. **Service Interfaces for External Dependencies**
- ✅ Service interfaces define contracts
- ✅ External dependencies are abstracted
- ✅ Services are testable

#### 10. **Business Rules Encapsulated in Domain Objects**
- ✅ Business rules are encapsulated in domain objects
- ✅ Business rules are enforced at the domain boundary
- ✅ Business rules are testable

### Domain Modeling Benefits

#### **Maintainability**
- ✅ Domain models are easy to understand and modify
- ✅ Business logic is centralized
- ✅ Changes are localized

#### **Testability**
- ✅ Domain models are easy to test
- ✅ Business logic is isolated
- ✅ Tests are focused and clear

#### **Reusability**
- ✅ Domain models can be reused
- ✅ Value objects are reusable
- ✅ Services are reusable

#### **Consistency**
- ✅ Domain models enforce consistency
- ✅ Business rules are centralized
- ✅ Validation is consistent

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Basic entity design
- [Order Entity](./03-order-entity.md) - Entity with business logic
- [Money Value Object](./02-money-value-object.md) - Value object example
- [EmailAddress Value Object](./04-email-address-value-object.md) - Validation example
- [Pricing Service](./05-pricing-service.md) - Domain service example
- [Customer Module](./06-customer-module.md) - Module organization
- [Best Practices for Domain Modeling](../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling) - Domain modeling concepts

/*
 * Navigation:
 * Previous: 12-testing-best-practices.md
 * Back to: [Best Practices for Domain Modeling](../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling)
 *
 * This completes the Java code samples for Domain-Driven Design
 */
