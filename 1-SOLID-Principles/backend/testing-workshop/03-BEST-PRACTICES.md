# Backend Testing Best Practices

## Overview

This guide covers best practices for writing effective tests in backend applications. These practices apply across all languages (C#, Java, Python, TypeScript) and help you create maintainable, reliable test suites.

## Core Principles

### 1. Test Behavior, Not Implementation

**❌ Bad - Testing Implementation**:
```csharp
// C# - Testing internal state
[Fact]
public void AddCustomer_ShouldUpdateInternalCache()
{
    var service = new CustomerService();
    service.AddCustomer(customer);
    
    // Testing implementation detail
    Assert.Equal(1, service._internalCache.Count);
}
```

**✅ Good - Testing Behavior**:
```csharp
// C# - Testing observable behavior
[Fact]
public void AddCustomer_ShouldPersistCustomer()
{
    var mockRepository = new Mock<ICustomerRepository>();
    var service = new CustomerService(mockRepository.Object);
    
    service.AddCustomer(customer);
    
    mockRepository.Verify(r => r.Save(customer), Times.Once);
}
```

### 2. Follow Arrange-Act-Assert (AAA)

Structure every test consistently:

```java
// Java example
@Test
void calculateOrderTotal_shouldSumItemPrices() {
    // Arrange - Set up test data and dependencies
    Order order = new Order();
    order.addItem(new OrderItem(1, 2, new BigDecimal("10.00")));
    order.addItem(new OrderItem(2, 1, new BigDecimal("20.00")));
    PriceCalculator calculator = new PriceCalculator();
    
    // Act - Execute the behavior being tested
    BigDecimal total = calculator.calculateTotal(order);
    
    // Assert - Verify the expected outcome
    assertThat(total).isEqualByComparingTo("40.00");
}
```

### 3. One Assertion Per Concept

**❌ Bad - Multiple Unrelated Assertions**:
```python
# Python - Testing too many things
def test_customer_creation():
    customer = create_customer("John", "john@example.com")
    assert customer.name == "John"
    assert customer.email == "john@example.com"
    assert customer.is_active is True
    assert customer.created_at is not None
    assert len(customer.orders) == 0
```

**✅ Good - Focused Tests**:
```python
# Python - One concept per test
def test_customer_created_with_correct_name():
    customer = create_customer("John", "john@example.com")
    assert customer.name == "John"

def test_customer_created_with_correct_email():
    customer = create_customer("John", "john@example.com")
    assert customer.email == "john@example.com"

def test_customer_created_as_active_by_default():
    customer = create_customer("John", "john@example.com")
    assert customer.is_active is True
```

### 4. Write Descriptive Test Names

**Pattern**: `Should_ExpectedBehavior_When_Condition`

```typescript
// TypeScript - Descriptive names
describe('OrderService', () => {
  it('should calculate correct total when order has multiple items', () => {});
  it('should throw error when order has no items', () => {});
  it('should apply discount when customer is premium', () => {});
  it('should send confirmation email when order is processed', () => {});
});
```

### 5. Keep Tests Independent

**❌ Bad - Dependent Tests**:
```csharp
// C# - Tests depend on execution order
public class CustomerServiceTests
{
    private static Customer _sharedCustomer;
    
    [Fact]
    public void Test1_CreateCustomer()
    {
        _sharedCustomer = _service.CreateCustomer("John");
        Assert.NotNull(_sharedCustomer);
    }
    
    [Fact]
    public void Test2_UpdateCustomer()
    {
        // Depends on Test1 running first!
        _service.UpdateCustomer(_sharedCustomer.Id, "Jane");
    }
}
```

**✅ Good - Independent Tests**:
```csharp
// C# - Each test is independent
public class CustomerServiceTests
{
    [Fact]
    public void CreateCustomer_ShouldReturnNewCustomer()
    {
        var customer = _service.CreateCustomer("John");
        Assert.NotNull(customer);
    }
    
    [Fact]
    public void UpdateCustomer_ShouldModifyExistingCustomer()
    {
        // Create its own test data
        var customer = _service.CreateCustomer("John");
        _service.UpdateCustomer(customer.Id, "Jane");
        
        var updated = _service.GetCustomer(customer.Id);
        Assert.Equal("Jane", updated.Name);
    }
}
```

## Test Organization

### File Structure

**Co-locate tests with source code**:
```
src/
├── services/
│   ├── CustomerService.cs
│   ├── CustomerService.Tests.cs
│   ├── OrderService.java
│   └── OrderService.Test.java
tests/
├── services/
│   ├── test_customer_service.py
│   └── test_order_service.py
```

### Test Suite Organization

```java
// Java - Organize tests by feature
class OrderServiceTest {
    
    @Nested
    class CreateOrder {
        @Test
        void shouldCreateOrderWithItems() {}
        
        @Test
        void shouldThrowExceptionWhenNoItems() {}
    }
    
    @Nested
    class CalculateTotal {
        @Test
        void shouldSumItemPrices() {}
        
        @Test
        void shouldApplyDiscount() {}
    }
}
```

## Test Data Management

### Use Test Builders

```csharp
// C# - Test builder pattern
public class CustomerBuilder
{
    private int _id = 1;
    private string _name = "John Doe";
    private string _email = "john@example.com";
    private bool _isActive = true;
    
    public CustomerBuilder WithId(int id)
    {
        _id = id;
        return this;
    }
    
    public CustomerBuilder WithName(string name)
    {
        _name = name;
        return this;
    }
    
    public CustomerBuilder Inactive()
    {
        _isActive = false;
        return this;
    }
    
    public Customer Build()
    {
        return new Customer(_id, _name, _email, _isActive);
    }
}

// Usage
[Fact]
public void ProcessOrder_ShouldFail_WhenCustomerInactive()
{
    var customer = new CustomerBuilder()
        .WithId(1)
        .Inactive()
        .Build();
    
    Assert.Throws<InvalidOperationException>(() => 
        _service.ProcessOrder(customer, order)
    );
}
```

### Use Factory Methods

```python
# Python - Factory methods
def create_test_customer(**overrides):
    defaults = {
        'id': 1,
        'name': 'John Doe',
        'email': 'john@example.com',
        'is_active': True
    }
    return Customer(**{**defaults, **overrides})

# Usage
def test_process_order_fails_when_customer_inactive():
    customer = create_test_customer(is_active=False)
    
    with pytest.raises(InvalidOperationException):
        service.process_order(customer, order)
```

### Use Object Mothers

```java
// Java - Object Mother pattern
public class CustomerMother {
    public static Customer regular() {
        return new Customer(1, "John Doe", "john@example.com");
    }
    
    public static Customer premium() {
        return new Customer(2, "Jane Smith", "jane@example.com", "PREMIUM");
    }
    
    public static Customer inactive() {
        Customer customer = regular();
        customer.deactivate();
        return customer;
    }
}

// Usage
@Test
void shouldApplyPremiumDiscount() {
    Customer customer = CustomerMother.premium();
    BigDecimal discount = calculator.calculateDiscount(customer);
    assertThat(discount).isEqualByComparingTo("0.10");
}
```

## Mocking Best Practices

### Mock External Dependencies Only

**✅ Mock**:
- Database connections
- HTTP clients
- File system
- External APIs
- Email services
- Message queues

**❌ Don't Mock**:
- Your own domain objects
- Value objects
- Simple data structures
- Pure functions

```typescript
// TypeScript - Good mocking
test('should save customer to database', async () => {
  // Mock external dependency
  const mockDb = {
    execute: jest.fn().mockResolvedValue({ rowsAffected: 1 }),
  };
  
  // Use real domain objects
  const customer = new Customer({ id: 1, name: 'John' });
  const repository = new CustomerRepository(mockDb);
  
  await repository.save(customer);
  
  expect(mockDb.execute).toHaveBeenCalled();
});
```

### Avoid Over-Mocking

**❌ Bad - Everything Mocked**:
```csharp
// C# - Too many mocks
var mockCustomer = new Mock<ICustomer>();
var mockAddress = new Mock<IAddress>();
var mockEmail = new Mock<IEmailAddress>();
var mockPhone = new Mock<IPhoneNumber>();
// This is excessive!
```

**✅ Good - Mock Only External Dependencies**:
```csharp
// C# - Reasonable mocking
var customer = new Customer(1, "John", new EmailAddress("john@example.com"));
var mockRepository = new Mock<ICustomerRepository>();
var service = new CustomerService(mockRepository.Object);
```

## Performance Best Practices

### Keep Tests Fast

**Target**: < 1 second per test

```python
# Python - Fast test with mocks
def test_send_email_fast():
    # Mock slow email service
    mock_smtp = Mock()
    service = EmailService(mock_smtp)
    
    service.send("to@example.com", "Subject", "Body")
    
    # Instant verification
    mock_smtp.send.assert_called_once()

# Slow test with real service
def test_send_email_slow():
    # Real SMTP connection - takes 2-3 seconds
    service = EmailService(SmtpClient())
    service.send("to@example.com", "Subject", "Body")
```

### Use In-Memory Databases for Integration Tests

```java
// Java - In-memory database for speed
@Test
void shouldSaveCustomerToDatabase() {
    // Use H2 in-memory database
    DataSource dataSource = new EmbeddedDatabaseBuilder()
        .setType(EmbeddedDatabaseType.H2)
        .addScript("schema.sql")
        .build();
    
    CustomerRepository repository = new CustomerRepository(dataSource);
    Customer customer = new Customer(1, "John", "john@example.com");
    
    repository.save(customer);
    
    Customer retrieved = repository.findById(1);
    assertThat(retrieved).isNotNull();
}
```

### Parallelize Test Execution

```bash
# C#
dotnet test --parallel

# Java
mvn test -T 4  # 4 threads

# Python
pytest -n auto  # Auto-detect CPU cores

# TypeScript
npm test -- --maxWorkers=4
```

## Error Handling Tests

### Test Expected Exceptions

```csharp
// C# - Testing exceptions
[Fact]
public void CreateCustomer_ShouldThrowException_WhenEmailInvalid()
{
    var service = new CustomerService();
    var customer = new Customer { Email = "invalid-email" };
    
    var exception = Assert.Throws<ValidationException>(() => 
        service.CreateCustomer(customer)
    );
    
    Assert.Contains("Invalid email", exception.Message);
}
```

```java
// Java - Testing exceptions
@Test
void createCustomer_shouldThrowException_whenEmailInvalid() {
    CustomerService service = new CustomerService();
    Customer customer = new Customer(1, "John", "invalid-email");
    
    assertThatThrownBy(() -> service.createCustomer(customer))
        .isInstanceOf(ValidationException.class)
        .hasMessageContaining("Invalid email");
}
```

```python
# Python - Testing exceptions
def test_create_customer_raises_exception_when_email_invalid():
    service = CustomerService()
    customer = Customer(id=1, name="John", email="invalid-email")
    
    with pytest.raises(ValidationException) as exc_info:
        service.create_customer(customer)
    
    assert "Invalid email" in str(exc_info.value)
```

```typescript
// TypeScript - Testing exceptions
test('createCustomer should throw exception when email invalid', () => {
  const service = new CustomerService();
  const customer = new Customer({ id: 1, name: 'John', email: 'invalid-email' });
  
  expect(() => service.createCustomer(customer))
    .toThrow('Invalid email');
});
```

### Test Error Recovery

```csharp
// C# - Testing retry logic
[Fact]
public async Task ProcessPayment_ShouldRetry_WhenTransientFailure()
{
    var mockGateway = new Mock<IPaymentGateway>();
    mockGateway
        .SetupSequence(g => g.Charge(It.IsAny<decimal>(), It.IsAny<string>()))
        .ThrowsAsync(new TransientException())
        .ThrowsAsync(new TransientException())
        .ReturnsAsync(new PaymentResult { Success = true });
    
    var service = new PaymentService(mockGateway.Object);
    
    var result = await service.ProcessPayment(100.00m, "tok_123");
    
    result.Success.Should().BeTrue();
    mockGateway.Verify(g => g.Charge(100.00m, "tok_123"), Times.Exactly(3));
}
```

## Edge Cases and Boundary Testing

### Test Boundary Conditions

```java
// Java - Boundary testing
@ParameterizedTest
@ValueSource(ints = {0, 1, 99, 100, 101, Integer.MAX_VALUE})
void shouldHandleQuantityBoundaries(int quantity) {
    OrderItem item = new OrderItem(1, quantity, new BigDecimal("10.00"));
    
    if (quantity <= 0) {
        assertThatThrownBy(() -> validator.validate(item))
            .isInstanceOf(ValidationException.class);
    } else if (quantity <= 100) {
        assertThatCode(() -> validator.validate(item))
            .doesNotThrowAnyException();
    } else {
        assertThatThrownBy(() -> validator.validate(item))
            .isInstanceOf(ValidationException.class)
            .hasMessageContaining("Maximum quantity exceeded");
    }
}
```

### Test Empty Collections

```python
# Python - Empty collection testing
def test_calculate_total_returns_zero_for_empty_order():
    calculator = PriceCalculator()
    order = Order(items=[])
    
    total = calculator.calculate_total(order)
    
    assert total == 0.00

def test_find_customers_returns_empty_list_when_none_exist():
    repository = CustomerRepository(mock_db)
    
    customers = repository.find_all()
    
    assert customers == []
```

### Test Null/None Values

```typescript
// TypeScript - Null handling
test('getCustomer should return null when not found', async () => {
  const mockDb = {
    query: jest.fn().mockResolvedValue([]),
  };
  const repository = new CustomerRepository(mockDb);
  
  const customer = await repository.findById(999);
  
  expect(customer).toBeNull();
});

test('processOrder should throw when customer is null', () => {
  const service = new OrderService();
  
  expect(() => service.processOrder(null, order))
    .toThrow('Customer cannot be null');
});
```

## Test Coverage

### Aim for Meaningful Coverage

**Target**: 80-90% code coverage

```bash
# C#
dotnet test /p:CollectCoverage=true /p:CoverageReportsDirectory=./coverage

# Java
mvn test jacoco:report

# Python
pytest --cov=src --cov-report=html

# TypeScript
npm test -- --coverage
```

### Don't Chase 100% Coverage

**Focus on**:
- Business logic (100%)
- Critical paths (100%)
- Error handling (90%+)
- Edge cases (80%+)

**Less important**:
- Simple getters/setters
- Configuration code
- Generated code

## Continuous Integration

### Run Tests Automatically

```yaml
# GitHub Actions example
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: |
          dotnet test
          # or mvn test, pytest, npm test
      - name: Check coverage
        run: |
          dotnet test /p:CollectCoverage=true /p:Threshold=80
```

### Fail Fast

```bash
# Stop on first failure
dotnet test --no-build --logger "console;verbosity=detailed" -- RunConfiguration.StopOnFirstFailure=true
```

## Common Anti-Patterns

### ❌ Testing Private Methods

```csharp
// Bad - Testing private method directly
[Fact]
public void TestPrivateMethod()
{
    var service = new CustomerService();
    var method = typeof(CustomerService).GetMethod("PrivateValidation", 
        BindingFlags.NonPublic | BindingFlags.Instance);
    var result = method.Invoke(service, new object[] { customer });
}

// Good - Test through public interface
[Fact]
public void CreateCustomer_ShouldValidate()
{
    var service = new CustomerService();
    var invalidCustomer = new Customer { Email = "" };
    
    Assert.Throws<ValidationException>(() => 
        service.CreateCustomer(invalidCustomer)
    );
}
```

### ❌ Brittle Tests

```java
// Bad - Breaks with any change
verify(mockService).doSomething(
    eq(42),
    eq("exact string"),
    eq(new DateTime(2024, 1, 1, 10, 30, 0))
);

// Good - Flexible matching
verify(mockService).doSomething(
    anyInt(),
    matches(".*string.*"),
    any(DateTime.class)
);
```

### ❌ Flaky Tests

```python
# Bad - Time-dependent test
def test_customer_created_today():
    customer = create_customer()
    assert customer.created_at.date() == datetime.now().date()
    # Fails at midnight!

# Good - Control time
def test_customer_created_at_current_time(freezer):
    freezer.move_to('2024-01-01 10:00:00')
    customer = create_customer()
    assert customer.created_at == datetime(2024, 1, 1, 10, 0, 0)
```

### ❌ Slow Tests

```typescript
// Bad - Real HTTP calls in unit test
test('should fetch user data', async () => {
  const service = new UserService();
  const user = await service.fetchUser(1);  // Real API call!
  expect(user).toBeDefined();
});

// Good - Mock HTTP calls
test('should fetch user data', async () => {
  const mockHttp = {
    get: jest.fn().mockResolvedValue({ id: 1, name: 'John' }),
  };
  const service = new UserService(mockHttp);
  const user = await service.fetchUser(1);
  expect(user).toBeDefined();
});
```

## Summary Checklist

Before considering your tests complete:

- [ ] All tests pass
- [ ] Tests are independent
- [ ] Tests are fast (< 1 second each)
- [ ] Tests have descriptive names
- [ ] Tests follow AAA pattern
- [ ] Edge cases covered
- [ ] Error conditions tested
- [ ] Coverage > 80%
- [ ] No flaky tests
- [ ] No skipped tests
- [ ] Tests are maintainable
- [ ] Tests document behavior

## Next Steps

1. Apply these practices to [Language-Specific Testing Guides](./README.md#language-specific-guides)
2. Use in [TDD Refactoring Process](./01-TDD-REFACTORING-PROCESS.md)
3. Reference [Test Doubles Guide](./02-TEST-DOUBLES.md)
4. Complete [SOLID Principle Workshops](./README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Good tests are fast, independent, repeatable, self-validating, and timely. Invest in test quality—it pays dividends throughout the project lifecycle.
