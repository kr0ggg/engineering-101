# Test Doubles Explained - Backend Testing

## Overview

Test doubles are objects that stand in for real dependencies during testing. They allow you to isolate the code under test and control the testing environment.

## The Five Types of Test Doubles

```
Test Doubles
├── Dummy    - Passed but never used
├── Stub     - Returns predetermined values
├── Spy      - Records calls for verification
├── Mock     - Verifies behavior expectations
└── Fake     - Working simplified implementation
```

---

## 1. Dummy Objects

**Purpose**: Satisfy parameter requirements without being used.

**When to Use**: When a method requires a parameter that isn't relevant to the test.

### C# Example

```csharp
public class OrderService
{
    public void ProcessOrder(Order order, ILogger logger, IMetrics metrics)
    {
        // logger and metrics might not be used in this test
        ValidateOrder(order);
    }
}

[Fact]
public void ProcessOrder_ShouldValidateOrder()
{
    // Arrange
    var order = new Order();
    var dummyLogger = new Mock<ILogger>().Object;  // Never used
    var dummyMetrics = new Mock<IMetrics>().Object; // Never used
    var service = new OrderService();
    
    // Act
    service.ProcessOrder(order, dummyLogger, dummyMetrics);
    
    // Assert
    // Test focuses on validation, not logging/metrics
}
```

### Java Example

```java
@Test
void processOrder_shouldValidateOrder() {
    // Arrange
    Order order = new Order();
    ILogger dummyLogger = mock(ILogger.class);  // Never used
    IMetrics dummyMetrics = mock(IMetrics.class); // Never used
    OrderService service = new OrderService();
    
    // Act
    service.processOrder(order, dummyLogger, dummyMetrics);
    
    // Assert - Focus on validation
}
```

### Python Example

```python
def test_process_order_validates_order():
    # Arrange
    order = Order()
    dummy_logger = Mock()  # Never used
    dummy_metrics = Mock()  # Never used
    service = OrderService()
    
    # Act
    service.process_order(order, dummy_logger, dummy_metrics)
    
    # Assert - Focus on validation
```

### TypeScript Example

```typescript
test('processOrder should validate order', () => {
  // Arrange
  const order = new Order();
  const dummyLogger = {} as ILogger;  // Never used
  const dummyMetrics = {} as IMetrics; // Never used
  const service = new OrderService();
  
  // Act
  service.processOrder(order, dummyLogger, dummyMetrics);
  
  // Assert - Focus on validation
});
```

---

## 2. Stub Objects

**Purpose**: Provide predetermined responses to method calls.

**When to Use**: When you need to control what a dependency returns.

### C# Example

```csharp
public interface IProductRepository
{
    Product FindById(int id);
    List<Product> FindAll();
}

[Fact]
public void CalculateOrderTotal_ShouldSumProductPrices()
{
    // Arrange - Stub returns predetermined products
    var stubRepository = new Mock<IProductRepository>();
    stubRepository
        .Setup(r => r.FindById(1))
        .Returns(new Product { Id = 1, Price = 10.00m });
    stubRepository
        .Setup(r => r.FindById(2))
        .Returns(new Product { Id = 2, Price = 20.00m });
    
    var service = new OrderService(stubRepository.Object);
    var order = new Order 
    { 
        Items = new List<OrderItem>
        {
            new OrderItem { ProductId = 1, Quantity = 2 },
            new OrderItem { ProductId = 2, Quantity = 1 }
        }
    };
    
    // Act
    var total = service.CalculateOrderTotal(order);
    
    // Assert
    total.Should().Be(40.00m); // (10 * 2) + (20 * 1)
}
```

### Java Example

```java
@Test
void calculateOrderTotal_shouldSumProductPrices() {
    // Arrange - Stub returns predetermined products
    IProductRepository stubRepository = mock(IProductRepository.class);
    when(stubRepository.findById(1))
        .thenReturn(new Product(1, "Product 1", new BigDecimal("10.00")));
    when(stubRepository.findById(2))
        .thenReturn(new Product(2, "Product 2", new BigDecimal("20.00")));
    
    OrderService service = new OrderService(stubRepository);
    Order order = new Order();
    order.addItem(new OrderItem(1, 2));
    order.addItem(new OrderItem(2, 1));
    
    // Act
    BigDecimal total = service.calculateOrderTotal(order);
    
    // Assert
    assertThat(total).isEqualByComparingTo("40.00");
}
```

### Python Example

```python
def test_calculate_order_total_sums_product_prices():
    # Arrange - Stub returns predetermined products
    stub_repository = Mock(spec=IProductRepository)
    stub_repository.find_by_id.side_effect = lambda id: {
        1: Product(id=1, price=10.00),
        2: Product(id=2, price=20.00)
    }[id]
    
    service = OrderService(stub_repository)
    order = Order(items=[
        OrderItem(product_id=1, quantity=2),
        OrderItem(product_id=2, quantity=1)
    ])
    
    # Act
    total = service.calculate_order_total(order)
    
    # Assert
    assert total == 40.00  # (10 * 2) + (20 * 1)
```

### TypeScript Example

```typescript
test('calculateOrderTotal should sum product prices', () => {
  // Arrange - Stub returns predetermined products
  const stubRepository: IProductRepository = {
    findById: jest.fn((id: number) => {
      const products = {
        1: { id: 1, name: 'Product 1', price: 10.00 },
        2: { id: 2, name: 'Product 2', price: 20.00 },
      };
      return products[id];
    }),
    findAll: jest.fn(),
  };
  
  const service = new OrderService(stubRepository);
  const order = new Order({
    items: [
      { productId: 1, quantity: 2 },
      { productId: 2, quantity: 1 },
    ],
  });
  
  // Act
  const total = service.calculateOrderTotal(order);
  
  // Assert
  expect(total).toBe(40.00);
});
```

---

## 3. Spy Objects

**Purpose**: Record information about how they were called.

**When to Use**: When you need to verify that specific methods were called with specific arguments.

### C# Example

```csharp
[Fact]
public void SendOrderConfirmation_ShouldCallEmailService()
{
    // Arrange - Spy records calls
    var spyEmailService = new Mock<IEmailService>();
    var service = new OrderService(spyEmailService.Object);
    var order = new Order { Id = 1, CustomerEmail = "customer@example.com" };
    
    // Act
    service.SendOrderConfirmation(order);
    
    // Assert - Verify the spy was called correctly
    spyEmailService.Verify(
        e => e.Send(
            "customer@example.com",
            "Order Confirmation",
            It.Is<string>(body => body.Contains("Order #1"))
        ),
        Times.Once
    );
}
```

### Java Example

```java
@Test
void sendOrderConfirmation_shouldCallEmailService() {
    // Arrange - Spy records calls
    IEmailService spyEmailService = mock(IEmailService.class);
    OrderService service = new OrderService(spyEmailService);
    Order order = new Order(1, "customer@example.com");
    
    // Act
    service.sendOrderConfirmation(order);
    
    // Assert - Verify the spy was called correctly
    verify(spyEmailService).send(
        eq("customer@example.com"),
        eq("Order Confirmation"),
        contains("Order #1")
    );
}
```

### Python Example

```python
def test_send_order_confirmation_calls_email_service():
    # Arrange - Spy records calls
    spy_email_service = Mock(spec=IEmailService)
    service = OrderService(spy_email_service)
    order = Order(id=1, customer_email="customer@example.com")
    
    # Act
    service.send_order_confirmation(order)
    
    # Assert - Verify the spy was called correctly
    spy_email_service.send.assert_called_once_with(
        "customer@example.com",
        "Order Confirmation",
        unittest.mock.ANY  # Body contains order details
    )
    
    # Can also check the actual arguments
    call_args = spy_email_service.send.call_args
    assert "Order #1" in call_args[0][2]
```

### TypeScript Example

```typescript
test('sendOrderConfirmation should call email service', () => {
  // Arrange - Spy records calls
  const spyEmailService = {
    send: jest.fn(),
  };
  const service = new OrderService(spyEmailService as IEmailService);
  const order = new Order({ id: 1, customerEmail: 'customer@example.com' });
  
  // Act
  service.sendOrderConfirmation(order);
  
  // Assert - Verify the spy was called correctly
  expect(spyEmailService.send).toHaveBeenCalledWith(
    'customer@example.com',
    'Order Confirmation',
    expect.stringContaining('Order #1')
  );
  expect(spyEmailService.send).toHaveBeenCalledTimes(1);
});
```

---

## 4. Mock Objects

**Purpose**: Verify behavior by setting expectations that must be met.

**When to Use**: When the interaction with a dependency is the behavior you're testing.

**Note**: Mocks are similar to spies but focus on behavior verification as the primary goal.

### C# Example

```csharp
[Fact]
public void ProcessPayment_ShouldChargeCorrectAmount()
{
    // Arrange - Mock expects specific behavior
    var mockPaymentGateway = new Mock<IPaymentGateway>();
    mockPaymentGateway
        .Setup(p => p.Charge(
            It.Is<decimal>(amount => amount == 100.00m),
            It.Is<string>(cardToken => cardToken == "tok_123")
        ))
        .Returns(new PaymentResult { Success = true, TransactionId = "txn_456" });
    
    var service = new PaymentService(mockPaymentGateway.Object);
    
    // Act
    var result = service.ProcessPayment(100.00m, "tok_123");
    
    // Assert - Verify mock expectations were met
    mockPaymentGateway.Verify(
        p => p.Charge(100.00m, "tok_123"),
        Times.Once
    );
    result.Success.Should().BeTrue();
}
```

### Java Example

```java
@Test
void processPayment_shouldChargeCorrectAmount() {
    // Arrange - Mock expects specific behavior
    IPaymentGateway mockPaymentGateway = mock(IPaymentGateway.class);
    when(mockPaymentGateway.charge(
        eq(new BigDecimal("100.00")),
        eq("tok_123")
    )).thenReturn(new PaymentResult(true, "txn_456"));
    
    PaymentService service = new PaymentService(mockPaymentGateway);
    
    // Act
    PaymentResult result = service.processPayment(
        new BigDecimal("100.00"),
        "tok_123"
    );
    
    // Assert - Verify mock expectations were met
    verify(mockPaymentGateway).charge(
        eq(new BigDecimal("100.00")),
        eq("tok_123")
    );
    assertThat(result.isSuccess()).isTrue();
}
```

### Python Example

```python
def test_process_payment_charges_correct_amount():
    # Arrange - Mock expects specific behavior
    mock_payment_gateway = Mock(spec=IPaymentGateway)
    mock_payment_gateway.charge.return_value = PaymentResult(
        success=True,
        transaction_id="txn_456"
    )
    
    service = PaymentService(mock_payment_gateway)
    
    # Act
    result = service.process_payment(100.00, "tok_123")
    
    # Assert - Verify mock expectations were met
    mock_payment_gateway.charge.assert_called_once_with(100.00, "tok_123")
    assert result.success is True
```

### TypeScript Example

```typescript
test('processPayment should charge correct amount', async () => {
  // Arrange - Mock expects specific behavior
  const mockPaymentGateway: IPaymentGateway = {
    charge: jest.fn().mockResolvedValue({
      success: true,
      transactionId: 'txn_456',
    }),
  };
  
  const service = new PaymentService(mockPaymentGateway);
  
  // Act
  const result = await service.processPayment(100.00, 'tok_123');
  
  // Assert - Verify mock expectations were met
  expect(mockPaymentGateway.charge).toHaveBeenCalledWith(100.00, 'tok_123');
  expect(mockPaymentGateway.charge).toHaveBeenCalledTimes(1);
  expect(result.success).toBe(true);
});
```

---

## 5. Fake Objects

**Purpose**: Provide a working but simplified implementation.

**When to Use**: When you need realistic behavior without the complexity/cost of the real implementation.

### C# Example

```csharp
// Fake implementation
public class FakeCustomerRepository : ICustomerRepository
{
    private readonly Dictionary<int, Customer> _customers = new();
    
    public void Save(Customer customer)
    {
        _customers[customer.Id] = customer;
    }
    
    public Customer FindById(int id)
    {
        return _customers.TryGetValue(id, out var customer) ? customer : null;
    }
    
    public List<Customer> FindAll()
    {
        return _customers.Values.ToList();
    }
}

[Fact]
public void CustomerService_ShouldManageCustomers()
{
    // Arrange - Fake provides working implementation
    var fakeRepository = new FakeCustomerRepository();
    var service = new CustomerService(fakeRepository);
    
    // Act
    var customer = new Customer { Id = 1, Name = "John Doe" };
    service.CreateCustomer(customer);
    var retrieved = service.GetCustomer(1);
    
    // Assert
    retrieved.Should().NotBeNull();
    retrieved.Name.Should().Be("John Doe");
}
```

### Java Example

```java
// Fake implementation
public class FakeCustomerRepository implements ICustomerRepository {
    private final Map<Integer, Customer> customers = new HashMap<>();
    
    @Override
    public void save(Customer customer) {
        customers.put(customer.getId(), customer);
    }
    
    @Override
    public Customer findById(int id) {
        return customers.get(id);
    }
    
    @Override
    public List<Customer> findAll() {
        return new ArrayList<>(customers.values());
    }
}

@Test
void customerService_shouldManageCustomers() {
    // Arrange - Fake provides working implementation
    ICustomerRepository fakeRepository = new FakeCustomerRepository();
    CustomerService service = new CustomerService(fakeRepository);
    
    // Act
    Customer customer = new Customer(1, "John Doe", "john@example.com");
    service.createCustomer(customer);
    Customer retrieved = service.getCustomer(1);
    
    // Assert
    assertThat(retrieved).isNotNull();
    assertThat(retrieved.getName()).isEqualTo("John Doe");
}
```

### Python Example

```python
# Fake implementation
class FakeCustomerRepository(ICustomerRepository):
    def __init__(self):
        self._customers = {}
    
    def save(self, customer):
        self._customers[customer.id] = customer
    
    def find_by_id(self, id):
        return self._customers.get(id)
    
    def find_all(self):
        return list(self._customers.values())

def test_customer_service_manages_customers():
    # Arrange - Fake provides working implementation
    fake_repository = FakeCustomerRepository()
    service = CustomerService(fake_repository)
    
    # Act
    customer = Customer(id=1, name="John Doe", email="john@example.com")
    service.create_customer(customer)
    retrieved = service.get_customer(1)
    
    # Assert
    assert retrieved is not None
    assert retrieved.name == "John Doe"
```

### TypeScript Example

```typescript
// Fake implementation
class FakeCustomerRepository implements ICustomerRepository {
  private customers = new Map<number, Customer>();
  
  save(customer: Customer): void {
    this.customers.set(customer.id, customer);
  }
  
  findById(id: number): Customer | null {
    return this.customers.get(id) || null;
  }
  
  findAll(): Customer[] {
    return Array.from(this.customers.values());
  }
}

test('customerService should manage customers', () => {
  // Arrange - Fake provides working implementation
  const fakeRepository = new FakeCustomerRepository();
  const service = new CustomerService(fakeRepository);
  
  // Act
  const customer = new Customer({ id: 1, name: 'John Doe' });
  service.createCustomer(customer);
  const retrieved = service.getCustomer(1);
  
  // Assert
  expect(retrieved).not.toBeNull();
  expect(retrieved?.name).toBe('John Doe');
});
```

---

## Comparison Table

| Type | Returns Data | Records Calls | Verifies Behavior | Has Logic |
|------|--------------|---------------|-------------------|-----------|
| **Dummy** | ❌ | ❌ | ❌ | ❌ |
| **Stub** | ✅ | ❌ | ❌ | ❌ |
| **Spy** | ✅ | ✅ | ❌ | ❌ |
| **Mock** | ✅ | ✅ | ✅ | ❌ |
| **Fake** | ✅ | ❌ | ❌ | ✅ |

---

## When to Use Each Type

### Use Dummy When:
- Parameter is required but not used in the test
- You don't care about the dependency's behavior
- Example: Logger in a validation test

### Use Stub When:
- You need to control what a dependency returns
- The return value affects the test outcome
- Example: Repository returning test data

### Use Spy When:
- You need to verify a method was called
- You want to check call arguments
- Example: Verifying email was sent

### Use Mock When:
- The interaction itself is what you're testing
- You want to set expectations upfront
- Example: Payment gateway integration

### Use Fake When:
- You need realistic behavior
- Stub/Mock would be too complex
- Real implementation is too slow/expensive
- Example: In-memory database

---

## Anti-Patterns to Avoid

### ❌ Over-Mocking

```csharp
// Bad: Mocking everything, including simple objects
var mockCustomer = new Mock<Customer>();
var mockAddress = new Mock<Address>();
var mockEmail = new Mock<EmailAddress>();

// Good: Only mock external dependencies
var customer = new Customer(1, "John", new EmailAddress("john@example.com"));
var mockRepository = new Mock<ICustomerRepository>();
```

### ❌ Mocking What You Don't Own

```csharp
// Bad: Mocking third-party library
var mockHttpClient = new Mock<HttpClient>();

// Good: Wrap it in your own interface
public interface IHttpClientWrapper
{
    Task<string> GetAsync(string url);
}

var mockWrapper = new Mock<IHttpClientWrapper>();
```

### ❌ Testing Implementation Details

```csharp
// Bad: Verifying internal method calls
mockRepository.Verify(r => r.InternalHelperMethod(), Times.Once);

// Good: Verify observable behavior
var result = service.GetCustomer(1);
result.Should().NotBeNull();
```

### ❌ Brittle Mocks

```csharp
// Bad: Mock breaks with any change
mockService.Setup(s => s.DoSomething(
    It.Is<int>(x => x == 42),
    It.Is<string>(s => s == "exact string"),
    It.Is<DateTime>(d => d == new DateTime(2024, 1, 1))
));

// Good: More flexible matching
mockService.Setup(s => s.DoSomething(
    It.IsAny<int>(),
    It.Is<string>(s => !string.IsNullOrEmpty(s)),
    It.IsAny<DateTime>()
));
```

---

## Best Practices

### ✅ Keep Test Doubles Simple

```csharp
// Good: Simple, focused stub
var stubRepository = new Mock<IProductRepository>();
stubRepository.Setup(r => r.FindById(1))
    .Returns(new Product { Id = 1, Price = 10.00m });
```

### ✅ Use Descriptive Names

```csharp
// Good: Clear what the double represents
var stubRepositoryReturningOutOfStockProduct = new Mock<IProductRepository>();
var mockEmailServiceThatShouldBeCalled = new Mock<IEmailService>();
```

### ✅ Verify Only What Matters

```csharp
// Good: Verify the important interaction
mockPaymentGateway.Verify(p => p.Charge(amount, token), Times.Once);

// Avoid: Verifying every single call
mockLogger.Verify(l => l.LogDebug(It.IsAny<string>()), Times.Exactly(3));
```

### ✅ Use Fakes for Complex Scenarios

```csharp
// Good: Fake for integration-like tests
var fakeRepository = new FakeCustomerRepository();
var service1 = new CustomerService(fakeRepository);
var service2 = new OrderService(fakeRepository);

// Both services can interact with the same fake
service1.CreateCustomer(customer);
service2.CreateOrder(customer.Id, items);
```

---

## Summary

**Test Doubles Hierarchy**:
```
Simplest → Most Complex
Dummy → Stub → Spy → Mock → Fake
```

**Key Principles**:
1. **Dummy**: Pass but don't use
2. **Stub**: Control return values
3. **Spy**: Record interactions
4. **Mock**: Verify behavior
5. **Fake**: Working implementation

**Remember**:
- Use the simplest double that meets your needs
- Don't over-mock
- Focus on testing behavior, not implementation
- Keep doubles simple and maintainable

## Next Steps

1. Practice with [Language-Specific Testing Guides](./README.md#language-specific-guides)
2. Apply to [TDD Refactoring Process](./01-TDD-REFACTORING-PROCESS.md)
3. Review [Testing Best Practices](./03-BEST-PRACTICES.md)

---

**Key Takeaway**: Choose the right test double for the job. Start simple (Dummy/Stub) and only use more complex doubles (Mock/Fake) when necessary.
