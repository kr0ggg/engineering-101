# Testing Best Practices - Java Example

**Section**: [Best Practices for DDD Unit Testing](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)

**Navigation**: [← Previous: Testing Anti-Patterns](./11-testing-anti-patterns.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - Testing Best Practices for DDD Unit Testing
// File: 2-Domain-Driven-Design/code-samples/java/12-testing-best-practices.java

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.junit.jupiter.params.provider.CsvSource;
import static org.junit.jupiter.api.Assertions.*;
import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

// ✅ GOOD: Testing Best Practices for DDD Unit Testing
@DisplayName("Testing Best Practices for DDD Unit Testing")
class TestingBestPracticesTest {
    
    @Nested
    @DisplayName("Test Behavior, Not Implementation")
    class TestBehaviorNotImplementationTests {
        
        @Test
        @DisplayName("✅ GOOD: Test business behavior")
        void shouldCalculateOrderTotalCorrectly() {
            // ✅ Test what the system does, not how it does it
            Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
            order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
            order.addItem(ProductId.of("product-2"), 1, Money.of(25.50, "USD"));
            
            // ✅ Test business behavior
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(57.48, "USD"));
            assertThat(order.canBeConfirmed()).isTrue();
        }
        
        @Test
        @DisplayName("✅ GOOD: Test business rules")
        void shouldEnforceMinimumOrderAmount() {
            // ✅ Test business rules
            Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
            order.addItem(ProductId.of("product-1"), 1, Money.of(5.00, "USD")); // Below $10 minimum
            
            // ✅ Test business rule enforcement
            assertThat(order.canBeConfirmed()).isFalse();
            
            order.addItem(ProductId.of("product-2"), 1, Money.of(10.00, "USD"));
            assertThat(order.canBeConfirmed()).isTrue();
        }
        
        @Test
        @DisplayName("✅ GOOD: Test value object behavior")
        void shouldHandleMoneyOperationsCorrectly() {
            // ✅ Test value object behavior
            Money money1 = Money.of(100.00, "USD");
            Money money2 = Money.of(50.00, "USD");
            
            // ✅ Test value object operations
            Money sum = money1.add(money2);
            Money difference = money1.subtract(money2);
            Money product = money1.multiply(2.0);
            
            assertThat(sum).isEqualTo(Money.of(150.00, "USD"));
            assertThat(difference).isEqualTo(Money.of(50.00, "USD"));
            assertThat(product).isEqualTo(Money.of(200.00, "USD"));
        }
    }
    
    @Nested
    @DisplayName("Use Descriptive Test Names")
    class UseDescriptiveTestNamesTests {
        
        @Test
        @DisplayName("✅ GOOD: Should register customer with valid name and email")
        void shouldRegisterCustomerWithValidNameAndEmail() {
            // ✅ Test name describes the behavior
            CustomerRepository mockRepository = mock(CustomerRepository.class);
            EmailService mockEmailService = mock(EmailService.class);
            
            CustomerService customerService = new CustomerService(mockRepository, mockEmailService);
            
            when(mockRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            doNothing().when(mockRepository).save(any(Customer.class));
            doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
            
            Customer customer = customerService.registerCustomer("John Doe", "john.doe@example.com");
            
            assertThat(customer.getName()).isEqualTo("John Doe");
            assertThat(customer.getEmail().getValue()).isEqualTo("john.doe@example.com");
        }
        
        @Test
        @DisplayName("✅ GOOD: Should throw exception when email already exists")
        void shouldThrowExceptionWhenEmailAlreadyExists() {
            // ✅ Test name describes the expected behavior
            CustomerRepository mockRepository = mock(CustomerRepository.class);
            EmailService mockEmailService = mock(EmailService.class);
            
            CustomerService customerService = new CustomerService(mockRepository, mockEmailService);
            
            Customer existingCustomer = new Customer(
                CustomerId.generate(), 
                "Jane Doe", 
                EmailAddress.of("john.doe@example.com")
            );
            when(mockRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.of(existingCustomer));
            
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.registerCustomer("John Doe", "john.doe@example.com");
            });
        }
        
        @Test
        @DisplayName("✅ GOOD: Should apply VIP customer discount")
        void shouldApplyVipCustomerDiscount() {
            // ✅ Test name describes the business behavior
            PricingService pricingService = new PricingService(
                mock(TaxCalculator.class),
                mock(ShippingCalculator.class),
                mock(DiscountRuleRepository.class)
            );
            
            Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
            order.addItem(ProductId.of("product-1"), 1, Money.of(100.00, "USD"));
            
            Customer customer = new Customer(CustomerId.of("customer-123"), "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.activate();
            customer.recordOrder(Money.of(1000, "USD")); // Make VIP
            
            Address address = new Address("123 Main St", "Anytown", "CA", "US", "12345");
            
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo("USD");
        }
    }
    
    @Nested
    @DisplayName("Test Edge Cases")
    class TestEdgeCasesTests {
        
        @Test
        @DisplayName("✅ GOOD: Test boundary conditions")
        void shouldHandleBoundaryConditions() {
            // ✅ Test boundary conditions
            Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
            
            // Test minimum order amount
            order.addItem(ProductId.of("product-1"), 1, Money.of(10.00, "USD")); // Exactly $10
            assertThat(order.canBeConfirmed()).isTrue();
            
            order.removeItem(ProductId.of("product-1"));
            order.addItem(ProductId.of("product-1"), 1, Money.of(9.99, "USD")); // Just below $10
            assertThat(order.canBeConfirmed()).isFalse();
        }
        
        @Test
        @DisplayName("✅ GOOD: Test error conditions")
        void shouldHandleErrorConditions() {
            // ✅ Test error conditions
            Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
            
            // Test adding item to confirmed order
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            order.confirm();
            
            assertThrows(IllegalStateException.class, () -> {
                order.addItem(ProductId.of("product-2"), 1, Money.of(10.00, "USD"));
            });
        }
        
        @Test
        @DisplayName("✅ GOOD: Test null and empty values")
        void shouldHandleNullAndEmptyValues() {
            // ✅ Test null and empty values
            assertThrows(IllegalArgumentException.class, () -> {
                new Order(null, CustomerId.of("customer-123"));
            });
            
            assertThrows(IllegalArgumentException.class, () -> {
                new Order(OrderId.generate(), null);
            });
            
            assertThrows(IllegalArgumentException.class, () -> {
                Money.of(-10.0, "USD");
            });
        }
    }
    
    @Nested
    @DisplayName("Use Proper Mocking")
    class UseProperMockingTests {
        
        @Test
        @DisplayName("✅ GOOD: Mock external dependencies")
        void shouldMockExternalDependencies() {
            // ✅ Mock external dependencies
            CustomerRepository mockRepository = mock(CustomerRepository.class);
            EmailService mockEmailService = mock(EmailService.class);
            
            CustomerService customerService = new CustomerService(mockRepository, mockEmailService);
            
            // ✅ Mock external dependencies, not domain objects
            when(mockRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            doNothing().when(mockRepository).save(any(Customer.class));
            doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
            
            Customer customer = customerService.registerCustomer("John Doe", "john.doe@example.com");
            
            assertThat(customer.getName()).isEqualTo("John Doe");
            
            // ✅ Verify interactions with mocks
            verify(mockRepository).findByEmail(any(EmailAddress.class));
            verify(mockRepository).save(customer);
            verify(mockEmailService).sendWelcomeEmail(customer);
        }
        
        @Test
        @DisplayName("✅ GOOD: Don't mock domain objects")
        void shouldNotMockDomainObjects() {
            // ✅ Don't mock domain objects
            Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
            Customer customer = new Customer(CustomerId.of("customer-123"), "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.activate();
            
            // ✅ Use real domain objects
            order.addItem(ProductId.of("product-1"), 1, Money.of(100.00, "USD"));
            
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(100.00, "USD"));
            assertThat(customer.isActive()).isTrue();
        }
        
        @Test
        @DisplayName("✅ GOOD: Don't mock value objects")
        void shouldNotMockValueObjects() {
            // ✅ Don't mock value objects
            Money money1 = Money.of(100.00, "USD");
            Money money2 = Money.of(50.00, "USD");
            EmailAddress email = EmailAddress.of("john.doe@example.com");
            
            // ✅ Use real value objects
            Money sum = money1.add(money2);
            assertThat(sum).isEqualTo(Money.of(150.00, "USD"));
            
            assertThat(email.getValue()).isEqualTo("john.doe@example.com");
            assertThat(email.getDomain()).isEqualTo("example.com");
        }
    }
    
    @Nested
    @DisplayName("Keep Tests Focused")
    class KeepTestsFocusedTests {
        
        @Test
        @DisplayName("✅ GOOD: Test one thing at a time")
        void shouldTestOneThingAtATime() {
            // ✅ Test one thing at a time
            Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
            
            // Test adding item
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            assertThat(order.getItemCount()).isEqualTo(1);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(15.99, "USD"));
        }
        
        @Test
        @DisplayName("✅ GOOD: Test specific business rule")
        void shouldTestSpecificBusinessRule() {
            // ✅ Test specific business rule
            Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
            
            // Test minimum order amount rule
            order.addItem(ProductId.of("product-1"), 1, Money.of(5.00, "USD")); // Below $10 minimum
            assertThat(order.canBeConfirmed()).isFalse();
            
            order.addItem(ProductId.of("product-2"), 1, Money.of(10.00, "USD"));
            assertThat(order.canBeConfirmed()).isTrue();
        }
        
        @Test
        @DisplayName("✅ GOOD: Test specific value object behavior")
        void shouldTestSpecificValueObjectBehavior() {
            // ✅ Test specific value object behavior
            Money money = Money.of(100.00, "USD");
            
            // Test addition
            Money sum = money.add(Money.of(50.00, "USD"));
            assertThat(sum).isEqualTo(Money.of(150.00, "USD"));
            
            // Test subtraction
            Money difference = money.subtract(Money.of(25.00, "USD"));
            assertThat(difference).isEqualTo(Money.of(75.00, "USD"));
        }
    }
    
    @Nested
    @DisplayName("Use Parameterized Tests")
    class UseParameterizedTestsTests {
        
        @ParameterizedTest
        @ValueSource(strings = {"USD", "EUR", "GBP", "JPY", "CAD", "AUD"})
        @DisplayName("✅ GOOD: Test with different currencies")
        void shouldCreateMoneyWithDifferentCurrencies(String currency) {
            // ✅ Test with different currencies
            Money money = Money.of(100.0, currency);
            
            assertThat(money.getAmount()).isEqualTo(100.0);
            assertThat(money.getCurrency()).isEqualTo(currency);
        }
        
        @ParameterizedTest
        @CsvSource({
            "VIP, 0.15",
            "Premium, 0.10",
            "Standard, 0.05",
            "Basic, 0.0"
        })
        @DisplayName("✅ GOOD: Test different customer types")
        void shouldApplyCorrectDiscountForCustomerType(String customerType, double expectedDiscount) {
            // ✅ Test different customer types
            Customer customer = new Customer(CustomerId.generate(), "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.activate();
            
            // Set customer type based on total spent
            switch (customerType) {
                case "VIP":
                    customer.recordOrder(Money.of(1000, "USD"));
                    break;
                case "Premium":
                    customer.recordOrder(Money.of(500, "USD"));
                    break;
                default:
                    // Standard or Basic
                    break;
            }
            
            assertThat(customer.getCustomerType()).isEqualTo(customerType);
        }
        
        @ParameterizedTest
        @CsvSource({
            "100.0, 50.0, 150.0",
            "0.0, 100.0, 100.0",
            "25.50, 75.25, 100.75",
            "999.99, 0.01, 1000.0"
        })
        @DisplayName("✅ GOOD: Test money addition with different values")
        void shouldAddMoneyWithDifferentValues(double amount1, double amount2, double expected) {
            // ✅ Test money addition with different values
            Money money1 = Money.of(amount1, "USD");
            Money money2 = Money.of(amount2, "USD");
            
            Money result = money1.add(money2);
            
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
    }
    
    @Nested
    @DisplayName("Use Test Data Builders")
    class UseTestDataBuildersTests {
        
        @Test
        @DisplayName("✅ GOOD: Use test data builders")
        void shouldUseTestDataBuilders() {
            // ✅ Use test data builders
            Order order = OrderTestDataBuilder.anOrder()
                .withCustomerId("customer-123")
                .withItem("product-1", 2, 15.99)
                .withItem("product-2", 1, 25.50)
                .build();
            
            assertThat(order.getCustomerId().getValue()).isEqualTo("customer-123");
            assertThat(order.getItemCount()).isEqualTo(2);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(57.48, "USD"));
        }
        
        @Test
        @DisplayName("✅ GOOD: Use test data builders for complex objects")
        void shouldUseTestDataBuildersForComplexObjects() {
            // ✅ Use test data builders for complex objects
            Customer customer = CustomerTestDataBuilder.aCustomer()
                .withName("John Doe")
                .withEmail("john.doe@example.com")
                .withStatus(CustomerStatus.ACTIVE)
                .withTotalSpent(1000.0)
                .build();
            
            assertThat(customer.getName()).isEqualTo("John Doe");
            assertThat(customer.getEmail().getValue()).isEqualTo("john.doe@example.com");
            assertThat(customer.getStatus()).isEqualTo(CustomerStatus.ACTIVE);
            assertThat(customer.isVip()).isTrue();
        }
    }
    
    @Nested
    @DisplayName("Use AssertJ for Better Assertions")
    class UseAssertJForBetterAssertionsTests {
        
        @Test
        @DisplayName("✅ GOOD: Use AssertJ for better assertions")
        void shouldUseAssertJForBetterAssertions() {
            // ✅ Use AssertJ for better assertions
            Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
            order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
            
            // ✅ AssertJ provides better error messages
            assertThat(order.getItemCount()).isEqualTo(2);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(31.98, "USD"));
            assertThat(order.canBeConfirmed()).isTrue();
            assertThat(order.getStatus()).isEqualTo(OrderStatus.DRAFT);
        }
        
        @Test
        @DisplayName("✅ GOOD: Use AssertJ for collection assertions")
        void shouldUseAssertJForCollectionAssertions() {
            // ✅ Use AssertJ for collection assertions
            Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
            order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
            order.addItem(ProductId.of("product-2"), 1, Money.of(25.50, "USD"));
            
            List<OrderItem> items = order.getItems();
            
            // ✅ AssertJ provides better collection assertions
            assertThat(items).hasSize(2);
            assertThat(items).extracting(OrderItem::getProductId)
                .extracting(ProductId::getValue)
                .containsExactlyInAnyOrder("product-1", "product-2");
        }
    }
    
    @Nested
    @DisplayName("Use Nested Tests for Organization")
    class UseNestedTestsForOrganizationTests {
        
        @Nested
        @DisplayName("Order Creation Tests")
        class OrderCreationTests {
            
            @Test
            @DisplayName("✅ GOOD: Should create order with valid data")
            void shouldCreateOrderWithValidData() {
                Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
                
                assertThat(order.getId()).isNotNull();
                assertThat(order.getCustomerId().getValue()).isEqualTo("customer-123");
                assertThat(order.getStatus()).isEqualTo(OrderStatus.DRAFT);
                assertThat(order.getItemCount()).isEqualTo(0);
            }
            
            @Test
            @DisplayName("✅ GOOD: Should throw exception when order ID is null")
            void shouldThrowExceptionWhenOrderIdIsNull() {
                assertThrows(IllegalArgumentException.class, () -> {
                    new Order(null, CustomerId.of("customer-123"));
                });
            }
        }
        
        @Nested
        @DisplayName("Order Item Management Tests")
        class OrderItemManagementTests {
            
            @Test
            @DisplayName("✅ GOOD: Should add item to order")
            void shouldAddItemToOrder() {
                Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
                
                order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
                
                assertThat(order.getItemCount()).isEqualTo(1);
                assertThat(order.getTotalAmount()).isEqualTo(Money.of(31.98, "USD"));
            }
            
            @Test
            @DisplayName("✅ GOOD: Should remove item from order")
            void shouldRemoveItemFromOrder() {
                Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
                order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
                
                order.removeItem(ProductId.of("product-1"));
                
                assertThat(order.getItemCount()).isEqualTo(0);
                assertThat(order.getTotalAmount()).isEqualTo(Money.of(0.0, "USD"));
            }
        }
    }
}

// ✅ GOOD: Test Data Builders
class OrderTestDataBuilder {
    private OrderId orderId;
    private CustomerId customerId;
    private List<OrderItem> items = new ArrayList<>();
    
    public static OrderTestDataBuilder anOrder() {
        return new OrderTestDataBuilder();
    }
    
    public OrderTestDataBuilder withCustomerId(String customerId) {
        this.customerId = CustomerId.of(customerId);
        return this;
    }
    
    public OrderTestDataBuilder withItem(String productId, int quantity, double unitPrice) {
        this.items.add(new OrderItem(
            ProductId.of(productId),
            quantity,
            Money.of(unitPrice, "USD")
        ));
        return this;
    }
    
    public Order build() {
        if (orderId == null) {
            orderId = OrderId.generate();
        }
        if (customerId == null) {
            customerId = CustomerId.of("customer-123");
        }
        
        Order order = new Order(orderId, customerId);
        for (OrderItem item : items) {
            order.addItem(item.getProductId(), item.getQuantity(), item.getUnitPrice());
        }
        
        return order;
    }
}

class CustomerTestDataBuilder {
    private CustomerId customerId;
    private String name;
    private EmailAddress email;
    private CustomerStatus status;
    private Money totalSpent;
    
    public static CustomerTestDataBuilder aCustomer() {
        return new CustomerTestDataBuilder();
    }
    
    public CustomerTestDataBuilder withName(String name) {
        this.name = name;
        return this;
    }
    
    public CustomerTestDataBuilder withEmail(String email) {
        this.email = EmailAddress.of(email);
        return this;
    }
    
    public CustomerTestDataBuilder withStatus(CustomerStatus status) {
        this.status = status;
        return this;
    }
    
    public CustomerTestDataBuilder withTotalSpent(double amount) {
        this.totalSpent = Money.of(amount, "USD");
        return this;
    }
    
    public Customer build() {
        if (customerId == null) {
            customerId = CustomerId.generate();
        }
        if (name == null) {
            name = "John Doe";
        }
        if (email == null) {
            email = EmailAddress.of("john.doe@example.com");
        }
        
        Customer customer = new Customer(customerId, name, email);
        
        if (status != null) {
            switch (status) {
                case ACTIVE:
                    customer.activate();
                    break;
                case INACTIVE:
                    customer.deactivate();
                    break;
                case SUSPENDED:
                    customer.suspend();
                    break;
            }
        }
        
        if (totalSpent != null) {
            customer.recordOrder(totalSpent);
        }
        
        return customer;
    }
}

// Example usage
public class TestingBestPracticesExample {
    public static void main(String[] args) {
        System.out.println("Testing Best Practices for DDD Unit Testing:");
        System.out.println("1. ✅ Test behavior, not implementation");
        System.out.println("2. ✅ Use descriptive test names");
        System.out.println("3. ✅ Test edge cases");
        System.out.println("4. ✅ Use proper mocking");
        System.out.println("5. ✅ Keep tests focused");
        System.out.println("6. ✅ Use parameterized tests");
        System.out.println("7. ✅ Use test data builders");
        System.out.println("8. ✅ Use AssertJ for better assertions");
        System.out.println("9. ✅ Use nested tests for organization");
        System.out.println("10. ✅ Test business rules and constraints");
    }
}
```

## Key Concepts Demonstrated

### Best Practices for DDD Unit Testing

#### 1. **Test Behavior, Not Implementation**
- ✅ Test what the system does, not how it does it
- ✅ Test business rules and constraints
- ✅ Test value object behavior
- ✅ Test domain service behavior

#### 2. **Use Descriptive Test Names**
- ✅ Test names should describe behavior
- ✅ Test names should be clear and specific
- ✅ Test names should focus on business value
- ✅ Test names should be easy to understand

#### 3. **Test Edge Cases**
- ✅ Test boundary conditions
- ✅ Test error conditions
- ✅ Test null and empty values
- ✅ Test extreme values

#### 4. **Use Proper Mocking**
- ✅ Mock external dependencies
- ✅ Don't mock domain objects
- ✅ Don't mock value objects
- ✅ Focus on business logic

#### 5. **Keep Tests Focused**
- ✅ Test one thing at a time
- ✅ Test specific business rules
- ✅ Test specific value object behavior
- ✅ Keep tests simple and clear

#### 6. **Use Parameterized Tests**
- ✅ Test multiple scenarios efficiently
- ✅ Test with different input values
- ✅ Test boundary conditions
- ✅ Reduce test duplication

#### 7. **Use Test Data Builders**
- ✅ Create complex test data easily
- ✅ Make tests more readable
- ✅ Reduce test setup code
- ✅ Make tests more maintainable

#### 8. **Use AssertJ for Better Assertions**
- ✅ Better error messages
- ✅ Fluent assertion API
- ✅ Collection assertions
- ✅ Custom assertions

#### 9. **Use Nested Tests for Organization**
- ✅ Organize tests by functionality
- ✅ Group related tests together
- ✅ Make test structure clear
- ✅ Improve test readability

#### 10. **Test Business Rules and Constraints**
- ✅ Test domain invariants
- ✅ Test business constraints
- ✅ Test validation rules
- ✅ Test error conditions

### Testing Best Practices Benefits

#### **Maintainability**
- ✅ Tests are easy to understand and modify
- ✅ Tests focus on business behavior
- ✅ Tests are not brittle
- ✅ Tests are well-organized

#### **Reliability**
- ✅ Tests are repeatable
- ✅ Tests are isolated
- ✅ Tests don't depend on external state
- ✅ Tests catch real bugs

#### **Readability**
- ✅ Test names are descriptive
- ✅ Test structure is clear
- ✅ Test data is well-organized
- ✅ Test assertions are clear

#### **Efficiency**
- ✅ Tests run quickly
- ✅ Tests are focused
- ✅ Tests use proper mocking
- ✅ Tests are parameterized

## Related Concepts

- [Order Tests](./07-order-tests.md) - Proper testing examples
- [Money Tests](./08-money-tests.md) - Value object testing
- [Pricing Service Tests](./09-pricing-service-tests.md) - Domain service testing
- [Customer Service Tests](./10-customer-service-tests.md) - Service testing with dependency injection
- [Testing Anti-Patterns](./11-testing-anti-patterns.md) - What to avoid
- [Best Practices for DDD Unit Testing](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing) - Testing concepts

/*
 * Navigation:
 * Previous: 11-testing-anti-patterns.md
 * Next: 13-domain-modeling-best-practices.md
 *
 * Back to: [Best Practices for DDD Unit Testing](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)
 */
