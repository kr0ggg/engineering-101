# Java Testing Patterns for SOLID Principles

## Overview

This guide covers common testing patterns for Java backend development, specifically focused on testing code that follows SOLID principles using JUnit 5, Mockito, and AssertJ.

## Testing Stack

- **JUnit 5** - Test framework
- **Mockito** - Mocking library
- **AssertJ** - Assertion library

## Basic Test Structure

### Arrange-Act-Assert (AAA) Pattern

```java
@Test
void methodName_condition_expectedResult() {
    // Arrange - Set up test data and dependencies
    Dependency dependency = mock(Dependency.class);
    SystemUnderTest sut = new SystemUnderTest(dependency);
    
    // Act - Execute the method being tested
    Result result = sut.methodToTest();
    
    // Assert - Verify the expected outcome
    assertThat(result).isEqualTo(expectedValue);
}
```

### Using @ParameterizedTest

```java
@ParameterizedTest
@CsvSource({
    "10, 2, 20",
    "15, 3, 45",
    "0, 5, 0"
})
void calculateTotal_shouldMultiplyPriceByQuantity(
    BigDecimal price, 
    int quantity, 
    BigDecimal expected) {
    // Arrange
    PriceCalculator calculator = new PriceCalculator();
    
    // Act
    BigDecimal result = calculator.calculateTotal(price, quantity);
    
    // Assert
    assertThat(result).isEqualByComparingTo(expected);
}
```

## Testing SOLID Principles

### 1. Single Responsibility Principle (SRP)

Test each responsibility independently.

#### After SRP - Focused Classes

```java
// Easy to test - single responsibility
public class CustomerValidator {
    public ValidationResult validate(Customer customer) {
        if (customer.getEmail() == null || customer.getEmail().isEmpty()) {
            return ValidationResult.failure("Email is required");
        }
        
        if (!isValidEmail(customer.getEmail())) {
            return ValidationResult.failure("Invalid email format");
        }
        
        return ValidationResult.success();
    }
}

// Focused test
@Test
void validate_shouldFail_whenEmailEmpty() {
    // Arrange
    CustomerValidator validator = new CustomerValidator();
    Customer customer = new Customer(1, "John", "");
    
    // Act
    ValidationResult result = validator.validate(customer);
    
    // Assert
    assertThat(result.isValid()).isFalse();
    assertThat(result.getErrors()).contains("Email is required");
}

@ParameterizedTest
@ValueSource(strings = {"invalid", "@example.com", "user@"})
void validate_shouldFail_whenEmailInvalid(String invalidEmail) {
    // Arrange
    CustomerValidator validator = new CustomerValidator();
    Customer customer = new Customer(1, "John", invalidEmail);
    
    // Act
    ValidationResult result = validator.validate(customer);
    
    // Assert
    assertThat(result.isValid()).isFalse();
    assertThat(result.getErrors()).contains("Invalid email format");
}
```

### 2. Open/Closed Principle (OCP)

Test base behavior and extensions independently.

#### Strategy Pattern Testing

```java
// Interface
public interface DiscountStrategy {
    Money applyDiscount(Money originalPrice);
}

// Implementation
public class PercentageDiscount implements DiscountStrategy {
    private final BigDecimal percentage;
    
    public PercentageDiscount(BigDecimal percentage) {
        this.percentage = percentage;
    }
    
    @Override
    public Money applyDiscount(Money originalPrice) {
        BigDecimal discount = originalPrice.getAmount()
            .multiply(percentage)
            .divide(new BigDecimal("100"));
        return new Money(originalPrice.getAmount().subtract(discount));
    }
}

// Test base contract
public abstract class DiscountStrategyContractTest {
    protected abstract DiscountStrategy createStrategy();
    
    @Test
    void applyDiscount_shouldNotReturnNegativePrice() {
        // Arrange
        DiscountStrategy strategy = createStrategy();
        Money price = new Money(new BigDecimal("10.00"));
        
        // Act
        Money result = strategy.applyDiscount(price);
        
        // Assert
        assertThat(result.getAmount()).isGreaterThanOrEqualTo(BigDecimal.ZERO);
    }
}

// Test specific implementation
class PercentageDiscountTest extends DiscountStrategyContractTest {
    @Override
    protected DiscountStrategy createStrategy() {
        return new PercentageDiscount(new BigDecimal("10"));
    }
    
    @ParameterizedTest
    @CsvSource({
        "100.00, 10, 90.00",
        "50.00, 20, 40.00",
        "75.00, 15, 63.75"
    })
    void applyDiscount_shouldCalculateCorrectPercentage(
        BigDecimal original, 
        BigDecimal percentage, 
        BigDecimal expected) {
        // Arrange
        DiscountStrategy strategy = new PercentageDiscount(percentage);
        Money price = new Money(original);
        
        // Act
        Money result = strategy.applyDiscount(price);
        
        // Assert
        assertThat(result.getAmount()).isEqualByComparingTo(expected);
    }
}
```

### 3. Liskov Substitution Principle (LSP)

Test that derived classes can substitute base classes.

#### Repository Pattern Testing

```java
// Base repository contract tests
public abstract class RepositoryContractTest<T, ID> {
    protected abstract Repository<T, ID> createRepository();
    protected abstract T createEntity(ID id);
    protected abstract ID createId();
    protected abstract ID getEntityId(T entity);
    
    @Test
    void save_shouldPersistEntity() {
        // Arrange
        Repository<T, ID> repository = createRepository();
        T entity = createEntity(createId());
        
        // Act
        repository.save(entity);
        
        // Assert
        T retrieved = repository.findById(getEntityId(entity));
        assertThat(retrieved).isNotNull();
    }
    
    @Test
    void findById_shouldReturnNull_whenNotExists() {
        // Arrange
        Repository<T, ID> repository = createRepository();
        ID nonExistentId = createId();
        
        // Act
        T result = repository.findById(nonExistentId);
        
        // Assert
        assertThat(result).isNull();
    }
}

// Concrete implementation tests
class CustomerRepositoryTest extends RepositoryContractTest<Customer, Integer> {
    private Connection mockConnection;
    
    @BeforeEach
    void setUp() {
        mockConnection = mock(Connection.class);
    }
    
    @Override
    protected Repository<Customer, Integer> createRepository() {
        return new CustomerRepository(mockConnection);
    }
    
    @Override
    protected Customer createEntity(Integer id) {
        return new Customer(id, "John Doe", "john@example.com");
    }
    
    @Override
    protected Integer createId() {
        return 1;
    }
    
    @Override
    protected Integer getEntityId(Customer entity) {
        return entity.getId();
    }
}
```

### 4. Interface Segregation Principle (ISP)

Test focused interfaces independently.

#### After ISP - Focused Interfaces

```java
// Focused interfaces
public interface CustomerReader {
    Customer findById(int id);
    Customer findByEmail(String email);
}

public interface CustomerWriter {
    void save(Customer customer);
    void delete(int id);
}

// Test only what you need
@Test
void getCustomer_usesReader() {
    // Arrange - Only mock what's needed
    CustomerReader mockReader = mock(CustomerReader.class);
    when(mockReader.findById(anyInt()))
        .thenReturn(new Customer(1, "John", "john@example.com"));
    
    CustomerDisplayService service = new CustomerDisplayService(mockReader);
    
    // Act
    Customer result = service.getCustomer(1);
    
    // Assert
    assertThat(result).isNotNull();
}

@Test
void createCustomer_usesWriter() {
    // Arrange - Only mock what's needed
    CustomerWriter mockWriter = mock(CustomerWriter.class);
    CustomerManagementService service = new CustomerManagementService(mockWriter);
    Customer customer = new Customer(1, "John", "john@example.com");
    
    // Act
    service.createCustomer(customer);
    
    // Assert
    verify(mockWriter).save(customer);
}
```

### 5. Dependency Inversion Principle (DIP)

Test against abstractions using dependency injection.

#### Testing with Injected Dependencies

```java
// Service depends on abstraction
public class OrderService {
    private final ProductRepository productRepository;
    private final PriceCalculator priceCalculator;
    private final EmailService emailService;
    
    public OrderService(
        ProductRepository productRepository,
        PriceCalculator priceCalculator,
        EmailService emailService) {
        this.productRepository = productRepository;
        this.priceCalculator = priceCalculator;
        this.emailService = emailService;
    }
    
    public Order createOrder(int customerId, List<OrderItem> items) {
        // Load products
        List<Product> products = productRepository.findByIds(
            items.stream().map(OrderItem::getProductId).collect(Collectors.toList())
        );
        
        // Calculate total
        Money total = priceCalculator.calculateTotal(items, products);
        
        // Create order
        Order order = new Order(customerId, items, total);
        
        // Send confirmation
        emailService.sendOrderConfirmation(order);
        
        return order;
    }
}

// Easy to test with mocks
@Test
void createOrder_shouldCalculateTotalAndSendEmail() {
    // Arrange
    ProductRepository mockProductRepo = mock(ProductRepository.class);
    PriceCalculator mockCalculator = mock(PriceCalculator.class);
    EmailService mockEmailService = mock(EmailService.class);
    
    List<Product> products = Arrays.asList(
        new Product(1, "Product 1", new Money(new BigDecimal("10.00"))),
        new Product(2, "Product 2", new Money(new BigDecimal("20.00")))
    );
    
    when(mockProductRepo.findByIds(anyList())).thenReturn(products);
    when(mockCalculator.calculateTotal(anyList(), anyList()))
        .thenReturn(new Money(new BigDecimal("40.00")));
    
    OrderService service = new OrderService(
        mockProductRepo,
        mockCalculator,
        mockEmailService
    );
    
    List<OrderItem> items = Arrays.asList(
        new OrderItem(1, 2),
        new OrderItem(2, 1)
    );
    
    // Act
    Order order = service.createOrder(1, items);
    
    // Assert
    assertThat(order.getTotal().getAmount()).isEqualByComparingTo("40.00");
    verify(mockEmailService).sendOrderConfirmation(argThat(o -> 
        o.getTotal().getAmount().compareTo(new BigDecimal("40.00")) == 0
    ));
}
```

## Advanced Testing Patterns

### Nested Tests

```java
@DisplayName("OrderService")
class OrderServiceTest {
    
    @Nested
    @DisplayName("when creating order")
    class CreateOrder {
        @Test
        @DisplayName("should calculate total correctly")
        void shouldCalculateTotal() {
            // Test implementation
        }
        
        @Test
        @DisplayName("should send confirmation email")
        void shouldSendEmail() {
            // Test implementation
        }
    }
    
    @Nested
    @DisplayName("when cancelling order")
    class CancelOrder {
        @Test
        @DisplayName("should refund payment")
        void shouldRefund() {
            // Test implementation
        }
    }
}
```

### Test Fixtures with @BeforeEach

```java
@ExtendWith(MockitoExtension.class)
class CustomerServiceTest {
    @Mock
    private CustomerRepository mockRepository;
    
    @Mock
    private EmailService mockEmailService;
    
    private CustomerService service;
    
    @BeforeEach
    void setUp() {
        service = new CustomerService(mockRepository, mockEmailService);
    }
    
    @Test
    void createCustomer_shouldSaveAndSendEmail() {
        // Arrange
        Customer customer = new Customer(1, "John", "john@example.com");
        
        // Act
        service.createCustomer(customer);
        
        // Assert
        verify(mockRepository).save(customer);
        verify(mockEmailService).sendWelcomeEmail(customer);
    }
}
```

### Custom Assertions

```java
public class CustomerAssert extends AbstractAssert<CustomerAssert, Customer> {
    public CustomerAssert(Customer actual) {
        super(actual, CustomerAssert.class);
    }
    
    public static CustomerAssert assertThat(Customer actual) {
        return new CustomerAssert(actual);
    }
    
    public CustomerAssert hasValidEmail() {
        isNotNull();
        if (!actual.getEmail().contains("@")) {
            failWithMessage("Expected customer to have valid email but was <%s>", 
                actual.getEmail());
        }
        return this;
    }
    
    public CustomerAssert isActive() {
        isNotNull();
        if (!actual.isActive()) {
            failWithMessage("Expected customer to be active but was inactive");
        }
        return this;
    }
}

// Usage
@Test
void createCustomer_shouldReturnValidCustomer() {
    Customer customer = service.createCustomer("John", "john@example.com");
    CustomerAssert.assertThat(customer)
        .hasValidEmail()
        .isActive();
}
```

### Test Data Builders

```java
public class OrderBuilder {
    private int id = 1;
    private int customerId = 1;
    private List<OrderItem> items = new ArrayList<>();
    private Money total = new Money(BigDecimal.ZERO);
    
    public OrderBuilder withId(int id) {
        this.id = id;
        return this;
    }
    
    public OrderBuilder forCustomer(int customerId) {
        this.customerId = customerId;
        return this;
    }
    
    public OrderBuilder withItem(int productId, int quantity) {
        items.add(new OrderItem(productId, quantity));
        return this;
    }
    
    public OrderBuilder withTotal(Money total) {
        this.total = total;
        return this;
    }
    
    public Order build() {
        return new Order(id, customerId, items, total);
    }
}

// Usage
@Test
void processOrder_shouldHandleMultipleItems() {
    Order order = new OrderBuilder()
        .forCustomer(1)
        .withItem(1, 2)
        .withItem(2, 1)
        .withTotal(new Money(new BigDecimal("40.00")))
        .build();
    
    boolean result = service.processOrder(order);
    assertThat(result).isTrue();
}
```

## Summary

**Key Testing Patterns**:
- Use AAA pattern consistently
- Test each SOLID principle appropriately
- Use @ParameterizedTest for multiple test cases
- Create contract tests for LSP
- Use focused interfaces for ISP
- Inject dependencies for DIP
- Use test builders for complex objects
- Create custom assertions for domain concepts

## Next Steps

1. Review [Mocking with Mockito](./02-MOCKING.md)
2. Learn [Integration Testing](./03-INTEGRATION-TESTING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Good testing patterns make your tests maintainable and your code more testable. Follow SOLID principles in both production and test code.
