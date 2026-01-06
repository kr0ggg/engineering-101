# Testing Anti-Patterns - Java Example

**Section**: [Testing Anti-Patterns to Avoid](../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid)

**Navigation**: [← Previous: Customer Service Tests](./10-customer-service-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - Testing Anti-Patterns to Avoid
// File: 2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns.java

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;
import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
import java.util.List;

// ❌ BAD: Testing Infrastructure Concerns
@DisplayName("Testing Anti-Patterns - Infrastructure Concerns")
class BadInfrastructureTests {
    
    @Test
    @DisplayName("❌ BAD: Testing database connection")
    void badTestDatabaseConnection() {
        // ❌ This is testing infrastructure, not business logic
        DatabaseConnection connection = new DatabaseConnection();
        assertTrue(connection.isConnected());
        
        // ❌ This test will break if database is down
        // ❌ This test doesn't verify business rules
        // ❌ This test is slow and unreliable
    }
    
    @Test
    @DisplayName("❌ BAD: Testing file system operations")
    void badTestFileSystemOperations() {
        // ❌ This is testing infrastructure, not business logic
        FileService fileService = new FileService();
        String result = fileService.readFile("test.txt");
        
        // ❌ This test depends on file system state
        // ❌ This test will break if file doesn't exist
        // ❌ This test doesn't verify business rules
    }
    
    @Test
    @DisplayName("❌ BAD: Testing network operations")
    void badTestNetworkOperations() {
        // ❌ This is testing infrastructure, not business logic
        HttpClient httpClient = new HttpClient();
        HttpResponse response = httpClient.get("https://api.example.com/data");
        
        // ❌ This test depends on network connectivity
        // ❌ This test will break if API is down
        // ❌ This test doesn't verify business rules
    }
}

// ❌ BAD: Testing Implementation Details
@DisplayName("Testing Anti-Patterns - Implementation Details")
class BadImplementationDetailTests {
    
    @Test
    @DisplayName("❌ BAD: Testing private method behavior")
    void badTestPrivateMethodBehavior() {
        // ❌ This is testing implementation details
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        
        // ❌ Using reflection to test private methods
        Method privateMethod = Order.class.getDeclaredMethod("calculateTotal");
        privateMethod.setAccessible(true);
        Money result = (Money) privateMethod.invoke(order);
        
        // ❌ This test will break if implementation changes
        // ❌ This test doesn't verify business behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName("❌ BAD: Testing internal state")
    void badTestInternalState() {
        // ❌ This is testing implementation details
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        
        // ❌ Testing internal fields directly
        Field itemsField = Order.class.getDeclaredField("items");
        itemsField.setAccessible(true);
        List<OrderItem> items = (List<OrderItem>) itemsField.get(order);
        
        // ❌ This test will break if internal structure changes
        // ❌ This test doesn't verify business behavior
        // ❌ This test is brittle and hard to maintain
    }
    
    @Test
    @DisplayName("❌ BAD: Testing method call order")
    void badTestMethodCallOrder() {
        // ❌ This is testing implementation details
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        
        // ❌ Testing that methods are called in specific order
        order.addItem(ProductId.of("product-1"), 1, Money.of(10.00, "USD"));
        order.addItem(ProductId.of("product-2"), 2, Money.of(15.00, "USD"));
        
        // ❌ This test will break if implementation changes
        // ❌ This test doesn't verify business behavior
        // ❌ This test is hard to maintain
    }
}

// ❌ BAD: Over-Mocking
@DisplayName("Testing Anti-Patterns - Over-Mocking")
class BadOverMockingTests {
    
    @Test
    @DisplayName("❌ BAD: Mocking domain objects")
    void badMockDomainObjects() {
        // ❌ This is over-mocking
        Order mockOrder = mock(Order.class);
        Customer mockCustomer = mock(Customer.class);
        Money mockMoney = mock(Money.class);
        
        when(mockOrder.getTotalAmount()).thenReturn(mockMoney);
        when(mockMoney.getAmount()).thenReturn(100.0);
        when(mockCustomer.getCustomerType()).thenReturn("VIP");
        
        // ❌ This test doesn't verify real business logic
        // ❌ This test is hard to maintain
        // ❌ This test doesn't catch real bugs
    }
    
    @Test
    @DisplayName("❌ BAD: Mocking value objects")
    void badMockValueObjects() {
        // ❌ This is over-mocking
        Money mockMoney = mock(Money.class);
        EmailAddress mockEmail = mock(EmailAddress.class);
        
        when(mockMoney.getAmount()).thenReturn(100.0);
        when(mockMoney.getCurrency()).thenReturn("USD");
        when(mockEmail.getValue()).thenReturn("test@example.com");
        
        // ❌ Value objects should be tested with real instances
        // ❌ This test doesn't verify real behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName("❌ BAD: Mocking everything")
    void badMockEverything() {
        // ❌ This is over-mocking
        Order mockOrder = mock(Order.class);
        Customer mockCustomer = mock(Customer.class);
        Money mockMoney = mock(Money.class);
        EmailAddress mockEmail = mock(EmailAddress.class);
        Address mockAddress = mock(Address.class);
        
        // ❌ Mocking everything makes tests meaningless
        // ❌ This test doesn't verify real behavior
        // ❌ This test is hard to maintain
    }
}

// ❌ BAD: Testing Implementation Instead of Behavior
@DisplayName("Testing Anti-Patterns - Implementation vs Behavior")
class BadImplementationVsBehaviorTests {
    
    @Test
    @DisplayName("❌ BAD: Testing method implementation")
    void badTestMethodImplementation() {
        // ❌ This is testing implementation, not behavior
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        
        // ❌ Testing that specific methods are called
        order.addItem(ProductId.of("product-1"), 1, Money.of(10.00, "USD"));
        
        // ❌ This test will break if implementation changes
        // ❌ This test doesn't verify business behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName("❌ BAD: Testing data structure details")
    void badTestDataStructureDetails() {
        // ❌ This is testing implementation, not behavior
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        order.addItem(ProductId.of("product-1"), 1, Money.of(10.00, "USD"));
        
        // ❌ Testing internal data structure
        List<OrderItem> items = order.getItems();
        assertThat(items).hasSize(1);
        assertThat(items.get(0).getProductId().getValue()).isEqualTo("product-1");
        
        // ❌ This test will break if implementation changes
        // ❌ This test doesn't verify business behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName("❌ BAD: Testing algorithm details")
    void badTestAlgorithmDetails() {
        // ❌ This is testing implementation, not behavior
        PricingService pricingService = new PricingService(
            mock(TaxCalculator.class),
            mock(ShippingCalculator.class),
            mock(DiscountRuleRepository.class)
        );
        
        // ❌ Testing that specific algorithm is used
        // ❌ This test will break if algorithm changes
        // ❌ This test doesn't verify business behavior
        // ❌ This test is hard to maintain
    }
}

// ❌ BAD: Brittle Tests
@DisplayName("Testing Anti-Patterns - Brittle Tests")
class BadBrittleTests {
    
    @Test
    @DisplayName("❌ BAD: Testing exact string values")
    void badTestExactStringValues() {
        // ❌ This is brittle testing
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        
        // ❌ Testing exact string representation
        String orderString = order.toString();
        assertThat(orderString).isEqualTo("Order{id=123, customerId=customer-123, status=Draft, items=0, total=$0.00}");
        
        // ❌ This test will break if toString() format changes
        // ❌ This test doesn't verify business behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName("❌ BAD: Testing exact date values")
    void badTestExactDateValues() {
        // ❌ This is brittle testing
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        
        // ❌ Testing exact date values
        LocalDateTime createdAt = order.getCreatedAt();
        assertThat(createdAt).isEqualTo(LocalDateTime.of(2024, 1, 1, 12, 0, 0));
        
        // ❌ This test will break if date changes
        // ❌ This test doesn't verify business behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName("❌ BAD: Testing exact numeric values")
    void badTestExactNumericValues() {
        // ❌ This is brittle testing
        Money money = Money.of(100.50, "USD");
        
        // ❌ Testing exact numeric values
        assertThat(money.getAmount()).isEqualTo(100.50);
        
        // ❌ This test will break if precision changes
        // ❌ This test doesn't verify business behavior
        // ❌ This test is hard to maintain
    }
}

// ❌ BAD: Test Data Pollution
@DisplayName("Testing Anti-Patterns - Test Data Pollution")
class BadTestDataPollutionTests {
    
    @Test
    @DisplayName("❌ BAD: Using shared test data")
    void badUseSharedTestData() {
        // ❌ This is test data pollution
        Order order = SharedTestData.getOrder();
        Customer customer = SharedTestData.getCustomer();
        
        // ❌ Shared test data can cause test interference
        // ❌ Tests may fail due to data from other tests
        // ❌ Tests are not isolated
    }
    
    @Test
    @DisplayName("❌ BAD: Using static test data")
    void badUseStaticTestData() {
        // ❌ This is test data pollution
        Order order = TestData.ORDER_1;
        Customer customer = TestData.CUSTOMER_1;
        
        // ❌ Static test data can cause test interference
        // ❌ Tests may fail due to data from other tests
        // ❌ Tests are not isolated
    }
    
    @Test
    @DisplayName("❌ BAD: Using database test data")
    void badUseDatabaseTestData() {
        // ❌ This is test data pollution
        Order order = orderRepository.findById("test-order-1");
        Customer customer = customerRepository.findById("test-customer-1");
        
        // ❌ Database test data can cause test interference
        // ❌ Tests may fail due to data from other tests
        // ❌ Tests are not isolated
    }
}

// ❌ BAD: Test Naming
@DisplayName("Testing Anti-Patterns - Test Naming")
class BadTestNamingTests {
    
    @Test
    @DisplayName("❌ BAD: Unclear test names")
    void test1() {
        // ❌ This test name is unclear
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        assertThat(order).isNotNull();
    }
    
    @Test
    @DisplayName("❌ BAD: Implementation-focused test names")
    void testAddItemMethod() {
        // ❌ This test name focuses on implementation
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        order.addItem(ProductId.of("product-1"), 1, Money.of(10.00, "USD"));
        assertThat(order.getItemCount()).isEqualTo(1);
    }
    
    @Test
    @DisplayName("❌ BAD: Vague test names")
    void testOrder() {
        // ❌ This test name is vague
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        assertThat(order).isNotNull();
    }
}

// ✅ GOOD: Proper Testing Examples
@DisplayName("Proper Testing Examples")
class GoodTestingExamples {
    
    @Test
    @DisplayName("✅ GOOD: Testing business behavior")
    void goodTestBusinessBehavior() {
        // ✅ This tests business behavior
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
        
        // ✅ Testing business behavior, not implementation
        assertThat(order.getTotalAmount()).isEqualTo(Money.of(31.98, "USD"));
        assertThat(order.canBeConfirmed()).isTrue();
    }
    
    @Test
    @DisplayName("✅ GOOD: Testing business rules")
    void goodTestBusinessRules() {
        // ✅ This tests business rules
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        order.addItem(ProductId.of("product-1"), 1, Money.of(5.00, "USD")); // Below $10 minimum
        
        // ✅ Testing business rules, not implementation
        assertThat(order.canBeConfirmed()).isFalse();
        
        order.addItem(ProductId.of("product-2"), 1, Money.of(10.00, "USD"));
        assertThat(order.canBeConfirmed()).isTrue();
    }
    
    @Test
    @DisplayName("✅ GOOD: Testing value object behavior")
    void goodTestValueObjectBehavior() {
        // ✅ This tests value object behavior
        Money money1 = Money.of(100.00, "USD");
        Money money2 = Money.of(50.00, "USD");
        
        // ✅ Testing value object behavior, not implementation
        Money result = money1.add(money2);
        assertThat(result).isEqualTo(Money.of(150.00, "USD"));
        assertThat(result.getCurrency()).isEqualTo("USD");
    }
    
    @Test
    @DisplayName("✅ GOOD: Testing domain service behavior")
    void goodTestDomainServiceBehavior() {
        // ✅ This tests domain service behavior
        PricingService pricingService = new PricingService(
            mock(TaxCalculator.class),
            mock(ShippingCalculator.class),
            mock(DiscountRuleRepository.class)
        );
        
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        order.addItem(ProductId.of("product-1"), 1, Money.of(100.00, "USD"));
        
        Customer customer = new Customer(CustomerId.of("customer-123"), "John Doe", EmailAddress.of("john.doe@example.com"));
        customer.activate();
        
        Address address = new Address("123 Main St", "Anytown", "CA", "US", "12345");
        
        // ✅ Testing domain service behavior, not implementation
        Money total = pricingService.calculateOrderTotal(order, customer, address);
        assertThat(total).isNotNull();
        assertThat(total.getCurrency()).isEqualTo("USD");
    }
    
    @Test
    @DisplayName("✅ GOOD: Testing with proper mocking")
    void goodTestWithProperMocking() {
        // ✅ This uses proper mocking
        CustomerRepository mockRepository = mock(CustomerRepository.class);
        EmailService mockEmailService = mock(EmailService.class);
        
        CustomerService customerService = new CustomerService(mockRepository, mockEmailService);
        
        // ✅ Mocking external dependencies, not domain objects
        when(mockRepository.findByEmail(any(EmailAddress.class)))
            .thenReturn(Optional.empty());
        doNothing().when(mockRepository).save(any(Customer.class));
        doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
        
        // ✅ Testing business behavior
        Customer customer = customerService.registerCustomer("John Doe", "john.doe@example.com");
        assertThat(customer.getName()).isEqualTo("John Doe");
        assertThat(customer.getEmail().getValue()).isEqualTo("john.doe@example.com");
    }
    
    @Test
    @DisplayName("✅ GOOD: Testing with descriptive names")
    void shouldRegisterCustomerWithValidNameAndEmail() {
        // ✅ This test name describes the behavior
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
}

// Example usage
public class TestingAntiPatternsExample {
    public static void main(String[] args) {
        System.out.println("Testing Anti-Patterns to Avoid:");
        System.out.println("1. ❌ Testing infrastructure concerns");
        System.out.println("2. ❌ Testing implementation details");
        System.out.println("3. ❌ Over-mocking");
        System.out.println("4. ❌ Testing implementation instead of behavior");
        System.out.println("5. ❌ Brittle tests");
        System.out.println("6. ❌ Test data pollution");
        System.out.println("7. ❌ Poor test naming");
        
        System.out.println("\nProper Testing Practices:");
        System.out.println("1. ✅ Test business behavior");
        System.out.println("2. ✅ Test business rules");
        System.out.println("3. ✅ Test value object behavior");
        System.out.println("4. ✅ Test domain service behavior");
        System.out.println("5. ✅ Use proper mocking");
        System.out.println("6. ✅ Use descriptive test names");
        System.out.println("7. ✅ Keep tests isolated");
    }
}
```

## Key Concepts Demonstrated

### Testing Anti-Patterns to Avoid

#### 1. **Testing Infrastructure Concerns**
- ❌ Testing database connections
- ❌ Testing file system operations
- ❌ Testing network operations
- ❌ These tests are slow, unreliable, and don't verify business logic

#### 2. **Testing Implementation Details**
- ❌ Testing private methods
- ❌ Testing internal state
- ❌ Testing method call order
- ❌ These tests break when implementation changes

#### 3. **Over-Mocking**
- ❌ Mocking domain objects
- ❌ Mocking value objects
- ❌ Mocking everything
- ❌ These tests don't verify real business logic

#### 4. **Testing Implementation Instead of Behavior**
- ❌ Testing method implementation
- ❌ Testing data structure details
- ❌ Testing algorithm details
- ❌ These tests break when implementation changes

#### 5. **Brittle Tests**
- ❌ Testing exact string values
- ❌ Testing exact date values
- ❌ Testing exact numeric values
- ❌ These tests break when format changes

#### 6. **Test Data Pollution**
- ❌ Using shared test data
- ❌ Using static test data
- ❌ Using database test data
- ❌ These tests can interfere with each other

#### 7. **Poor Test Naming**
- ❌ Unclear test names
- ❌ Implementation-focused test names
- ❌ Vague test names
- ❌ These tests are hard to understand

### Proper Testing Practices

#### **Test Business Behavior**
- ✅ Test what the system does, not how it does it
- ✅ Test business rules and constraints
- ✅ Test value object behavior
- ✅ Test domain service behavior

#### **Use Proper Mocking**
- ✅ Mock external dependencies
- ✅ Don't mock domain objects
- ✅ Don't mock value objects
- ✅ Focus on business logic

#### **Use Descriptive Test Names**
- ✅ Test names should describe behavior
- ✅ Test names should be clear and specific
- ✅ Test names should focus on business value
- ✅ Test names should be easy to understand

#### **Keep Tests Isolated**
- ✅ Each test should be independent
- ✅ Tests should not depend on each other
- ✅ Tests should use fresh data
- ✅ Tests should be repeatable

## Related Concepts

- [Order Tests](./07-order-tests.md) - Proper testing examples
- [Money Tests](./08-money-tests.md) - Value object testing
- [Pricing Service Tests](./09-pricing-service-tests.md) - Domain service testing
- [Customer Service Tests](./10-customer-service-tests.md) - Service testing with dependency injection
- [Testing Anti-Patterns to Avoid](../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid) - Testing concepts

/*
 * Navigation:
 * Previous: 10-customer-service-tests.md
 * Next: 12-testing-best-practices.md
 *
 * Back to: [Testing Anti-Patterns to Avoid](../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid)
 */
