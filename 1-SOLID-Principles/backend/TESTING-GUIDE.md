# Backend Testing Guide - Multi-Language

## Overview

This guide covers testing strategies for backend applications following SOLID principles. Examples are provided in C#, Java, Python, and TypeScript, showing how to write effective unit tests that validate your refactored code.

## Testing Stack by Language

### C# (.NET)
- **xUnit** - Test framework
- **Moq** - Mocking library
- **FluentAssertions** - Assertion library
- **AutoFixture** - Test data generation

### Java
- **JUnit 5** - Test framework
- **Mockito** - Mocking library
- **AssertJ** - Fluent assertions
- **TestContainers** - Integration testing

### Python
- **pytest** - Test framework
- **pytest-mock** - Mocking utilities
- **unittest.mock** - Built-in mocking
- **faker** - Test data generation

### TypeScript (Node.js)
- **Jest** - Test framework and mocking
- **ts-jest** - TypeScript support
- **supertest** - HTTP testing
- **@faker-js/faker** - Test data generation

## Running Tests

### C# (.NET)
```bash
cd backend/reference-application/Dotnet

# Run all tests
dotnet test

# Run with coverage
dotnet test /p:CollectCoverage=true

# Run specific test
dotnet test --filter "FullyQualifiedName~CustomerServiceTests"

# Watch mode
dotnet watch test
```

### Java
```bash
cd backend/reference-application/Java

# Run all tests
mvn test

# Run with coverage
mvn test jacoco:report

# Run specific test
mvn test -Dtest=CustomerServiceTest

# Skip tests during build
mvn install -DskipTests
```

### Python
```bash
cd backend/reference-application/Python

# Activate virtual environment
source venv/bin/activate

# Run all tests
pytest

# Run with coverage
pytest --cov=src --cov-report=html

# Run specific test
pytest tests/test_customer_service.py

# Watch mode
pytest-watch
```

### TypeScript (Node.js)
```bash
cd backend/reference-application/TypeScript

# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Run specific test
npm test -- CustomerService.test

# Watch mode
npm test -- --watch
```

## Testing Patterns by SOLID Principle

### 1. Single Responsibility Principle (SRP)

When refactoring to follow SRP, test each responsibility independently.

#### Before Refactoring - Characterization Tests

**C# Example:**
```csharp
using Xunit;
using Moq;
using FluentAssertions;

namespace EcommerceApp.Tests
{
    public class EcommerceManagerTests
    {
        private readonly Mock<IDbConnection> _mockConnection;
        private readonly EcommerceManager _manager;

        public EcommerceManagerTests()
        {
            _mockConnection = new Mock<IDbConnection>();
            _manager = new EcommerceManager(_mockConnection.Object);
        }

        [Fact]
        public void CreateCustomer_ShouldSaveToDatabase()
        {
            // Arrange
            var customer = new Customer 
            { 
                Id = 1, 
                Name = "John Doe", 
                Email = "john@example.com" 
            };

            // Act
            _manager.CreateCustomer(customer);

            // Assert
            _mockConnection.Verify(
                c => c.Execute(
                    It.Is<string>(sql => sql.Contains("INSERT INTO customers")),
                    It.IsAny<object>()
                ),
                Times.Once
            );
        }

        [Fact]
        public void ProcessOrder_ShouldCalculateTotalAndSendEmail()
        {
            // Arrange
            var order = new Order 
            { 
                Id = 1, 
                CustomerId = 1,
                Items = new List<OrderItem>
                {
                    new OrderItem { ProductId = 1, Quantity = 2, Price = 10.00m }
                }
            };

            // Act
            var result = _manager.ProcessOrder(order);

            // Assert
            result.Total.Should().Be(20.00m);
            // This test is doing too much - violates SRP
        }
    }
}
```

**Java Example:**
```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

class EcommerceManagerTest {
    
    @Mock
    private Connection connection;
    
    private EcommerceManager manager;
    
    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        manager = new EcommerceManager(connection);
    }
    
    @Test
    void createCustomer_shouldSaveToDatabase() {
        // Arrange
        Customer customer = new Customer(1, "John Doe", "john@example.com");
        
        // Act
        manager.createCustomer(customer);
        
        // Assert
        verify(connection).execute(
            contains("INSERT INTO customers"),
            any()
        );
    }
    
    @Test
    void processOrder_shouldCalculateTotalAndSendEmail() {
        // Arrange
        Order order = new Order(1, 1);
        order.addItem(new OrderItem(1, 2, new BigDecimal("10.00")));
        
        // Act
        OrderResult result = manager.processOrder(order);
        
        // Assert
        assertThat(result.getTotal()).isEqualByComparingTo("20.00");
    }
}
```

**Python Example:**
```python
import pytest
from unittest.mock import Mock, patch
from ecommerce_manager import EcommerceManager
from models import Customer, Order, OrderItem

class TestEcommerceManager:
    
    @pytest.fixture
    def mock_connection(self):
        return Mock()
    
    @pytest.fixture
    def manager(self, mock_connection):
        return EcommerceManager(mock_connection)
    
    def test_create_customer_should_save_to_database(self, manager, mock_connection):
        # Arrange
        customer = Customer(id=1, name="John Doe", email="john@example.com")
        
        # Act
        manager.create_customer(customer)
        
        # Assert
        mock_connection.execute.assert_called_once()
        args = mock_connection.execute.call_args[0]
        assert "INSERT INTO customers" in args[0]
    
    def test_process_order_should_calculate_total(self, manager):
        # Arrange
        order = Order(id=1, customer_id=1)
        order.add_item(OrderItem(product_id=1, quantity=2, price=10.00))
        
        # Act
        result = manager.process_order(order)
        
        # Assert
        assert result.total == 20.00
```

**TypeScript Example:**
```typescript
import { EcommerceManager } from './EcommerceManager';
import { Customer, Order, OrderItem } from './models';

describe('EcommerceManager', () => {
  let mockConnection: any;
  let manager: EcommerceManager;

  beforeEach(() => {
    mockConnection = {
      execute: jest.fn(),
      query: jest.fn(),
    };
    manager = new EcommerceManager(mockConnection);
  });

  it('should save customer to database', async () => {
    // Arrange
    const customer: Customer = {
      id: 1,
      name: 'John Doe',
      email: 'john@example.com',
    };

    // Act
    await manager.createCustomer(customer);

    // Assert
    expect(mockConnection.execute).toHaveBeenCalledWith(
      expect.stringContaining('INSERT INTO customers'),
      expect.any(Object)
    );
  });

  it('should process order and calculate total', async () => {
    // Arrange
    const order: Order = {
      id: 1,
      customerId: 1,
      items: [
        { productId: 1, quantity: 2, price: 10.00 },
      ],
    };

    // Act
    const result = await manager.processOrder(order);

    // Assert
    expect(result.total).toBe(20.00);
  });
});
```

#### After Refactoring - Separated Tests

**C# Example - CustomerRepository Tests:**
```csharp
public class CustomerRepositoryTests
{
    private readonly Mock<IDbConnection> _mockConnection;
    private readonly CustomerRepository _repository;

    public CustomerRepositoryTests()
    {
        _mockConnection = new Mock<IDbConnection>();
        _repository = new CustomerRepository(_mockConnection.Object);
    }

    [Fact]
    public void Save_ShouldInsertCustomerIntoDatabase()
    {
        // Arrange
        var customer = new Customer(
            new CustomerId(1), 
            "John Doe", 
            new EmailAddress("john@example.com")
        );

        // Act
        _repository.Save(customer);

        // Assert
        _mockConnection.Verify(
            c => c.Execute(
                "INSERT INTO customers (id, name, email) VALUES (@Id, @Name, @Email)",
                It.Is<object>(p => 
                    p.GetType().GetProperty("Id")?.GetValue(p)?.ToString() == "1"
                )
            ),
            Times.Once
        );
    }

    [Fact]
    public async Task FindById_ShouldReturnCustomer_WhenExists()
    {
        // Arrange
        var customerId = new CustomerId(1);
        _mockConnection
            .Setup(c => c.QueryFirstOrDefaultAsync<CustomerDto>(
                It.IsAny<string>(),
                It.IsAny<object>()
            ))
            .ReturnsAsync(new CustomerDto 
            { 
                Id = 1, 
                Name = "John Doe", 
                Email = "john@example.com" 
            });

        // Act
        var customer = await _repository.FindById(customerId);

        // Assert
        customer.Should().NotBeNull();
        customer.Name.Should().Be("John Doe");
    }

    [Fact]
    public async Task FindById_ShouldReturnNull_WhenNotExists()
    {
        // Arrange
        var customerId = new CustomerId(999);
        _mockConnection
            .Setup(c => c.QueryFirstOrDefaultAsync<CustomerDto>(
                It.IsAny<string>(),
                It.IsAny<object>()
            ))
            .ReturnsAsync((CustomerDto)null);

        // Act
        var customer = await _repository.FindById(customerId);

        // Assert
        customer.Should().BeNull();
    }
}

public class PriceCalculatorTests
{
    private readonly PriceCalculator _calculator;

    public PriceCalculatorTests()
    {
        _calculator = new PriceCalculator();
    }

    [Theory]
    [InlineData(10.00, 2, 20.00)]
    [InlineData(15.50, 3, 46.50)]
    [InlineData(9.99, 1, 9.99)]
    public void CalculateItemTotal_ShouldReturnCorrectAmount(
        decimal price, 
        int quantity, 
        decimal expected)
    {
        // Arrange
        var money = new Money(price, Currency.USD);

        // Act
        var result = _calculator.CalculateItemTotal(money, quantity);

        // Assert
        result.Amount.Should().Be(expected);
    }

    [Fact]
    public void CalculateOrderTotal_ShouldSumAllItems()
    {
        // Arrange
        var items = new List<OrderItem>
        {
            new OrderItem(new ProductId(1), new Money(10.00m, Currency.USD), 2),
            new OrderItem(new ProductId(2), new Money(15.00m, Currency.USD), 1),
        };

        // Act
        var total = _calculator.CalculateOrderTotal(items);

        // Assert
        total.Amount.Should().Be(35.00m);
    }
}
```

### 2. Open/Closed Principle (OCP)

Test that classes are extensible without modification.

**C# Example - Strategy Pattern:**
```csharp
public interface IDiscountStrategy
{
    Money ApplyDiscount(Money originalPrice);
}

public class PercentageDiscountTests
{
    [Theory]
    [InlineData(100.00, 10, 90.00)]
    [InlineData(50.00, 20, 40.00)]
    [InlineData(75.00, 15, 63.75)]
    public void ApplyDiscount_ShouldReducePriceByPercentage(
        decimal original, 
        int percentage, 
        decimal expected)
    {
        // Arrange
        var strategy = new PercentageDiscount(percentage);
        var price = new Money(original, Currency.USD);

        // Act
        var discounted = strategy.ApplyDiscount(price);

        // Assert
        discounted.Amount.Should().Be(expected);
    }
}

public class FixedAmountDiscountTests
{
    [Theory]
    [InlineData(100.00, 10.00, 90.00)]
    [InlineData(50.00, 5.00, 45.00)]
    [InlineData(25.00, 30.00, 0.00)] // Can't go negative
    public void ApplyDiscount_ShouldReducePriceByFixedAmount(
        decimal original, 
        decimal discount, 
        decimal expected)
    {
        // Arrange
        var strategy = new FixedAmountDiscount(new Money(discount, Currency.USD));
        var price = new Money(original, Currency.USD);

        // Act
        var discounted = strategy.ApplyDiscount(price);

        // Assert
        discounted.Amount.Should().Be(expected);
    }
}

// Test that new strategies can be added without modifying existing code
public class BuyOneGetOneDiscountTests
{
    [Fact]
    public void ApplyDiscount_ShouldGive50PercentOff()
    {
        // Arrange
        var strategy = new BuyOneGetOneDiscount();
        var price = new Money(100.00m, Currency.USD);

        // Act
        var discounted = strategy.ApplyDiscount(price);

        // Assert
        discounted.Amount.Should().Be(50.00m);
    }
}
```

### 3. Liskov Substitution Principle (LSP)

Test that derived classes can substitute base classes.

**Java Example - Contract Testing:**
```java
// Base test class for all repository implementations
abstract class RepositoryContractTest<T, ID> {
    
    protected abstract Repository<T, ID> createRepository();
    protected abstract T createEntity(ID id);
    protected abstract ID createId();
    
    @Test
    void save_shouldPersistEntity() {
        // Arrange
        Repository<T, ID> repository = createRepository();
        T entity = createEntity(createId());
        
        // Act
        repository.save(entity);
        
        // Assert
        T retrieved = repository.findById(entity.getId());
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
    
    @Test
    void delete_shouldRemoveEntity() {
        // Arrange
        Repository<T, ID> repository = createRepository();
        T entity = createEntity(createId());
        repository.save(entity);
        
        // Act
        repository.delete(entity.getId());
        
        // Assert
        T retrieved = repository.findById(entity.getId());
        assertThat(retrieved).isNull();
    }
}

// Concrete test implementations
class CustomerRepositoryTest extends RepositoryContractTest<Customer, CustomerId> {
    
    @Override
    protected Repository<Customer, CustomerId> createRepository() {
        return new CustomerRepository(mockConnection);
    }
    
    @Override
    protected Customer createEntity(CustomerId id) {
        return new Customer(id, "John Doe", new EmailAddress("john@example.com"));
    }
    
    @Override
    protected CustomerId createId() {
        return new CustomerId(UUID.randomUUID().toString());
    }
}

class OrderRepositoryTest extends RepositoryContractTest<Order, OrderId> {
    
    @Override
    protected Repository<Order, OrderId> createRepository() {
        return new OrderRepository(mockConnection);
    }
    
    @Override
    protected Order createEntity(OrderId id) {
        return new Order(id, new CustomerId("customer-1"));
    }
    
    @Override
    protected OrderId createId() {
        return new OrderId(UUID.randomUUID().toString());
    }
}
```

### 4. Interface Segregation Principle (ISP)

Test focused interfaces independently.

**Python Example:**
```python
# Before ISP - Fat interface
class TestFatRepository:
    """Tests for repository with too many methods"""
    
    def test_customer_repository_forced_to_implement_unused_methods(self):
        # CustomerRepository forced to implement product-specific methods
        repo = CustomerRepository()
        
        # These methods shouldn't exist on CustomerRepository
        with pytest.raises(AttributeError):
            repo.get_products_by_category("electronics")
        
        with pytest.raises(AttributeError):
            repo.update_inventory(product_id=1, quantity=10)

# After ISP - Segregated interfaces
class TestCustomerReader:
    """Tests for reading customer data"""
    
    @pytest.fixture
    def reader(self):
        return CustomerReader(mock_connection)
    
    def test_find_by_id_returns_customer(self, reader):
        # Arrange
        customer_id = CustomerId("customer-1")
        
        # Act
        customer = reader.find_by_id(customer_id)
        
        # Assert
        assert customer is not None
        assert customer.id == customer_id
    
    def test_find_by_email_returns_customer(self, reader):
        # Arrange
        email = EmailAddress("john@example.com")
        
        # Act
        customer = reader.find_by_email(email)
        
        # Assert
        assert customer is not None
        assert customer.email == email

class TestCustomerWriter:
    """Tests for writing customer data"""
    
    @pytest.fixture
    def writer(self):
        return CustomerWriter(mock_connection)
    
    def test_save_persists_customer(self, writer):
        # Arrange
        customer = Customer(
            id=CustomerId("customer-1"),
            name="John Doe",
            email=EmailAddress("john@example.com")
        )
        
        # Act
        writer.save(customer)
        
        # Assert
        mock_connection.execute.assert_called_once()
    
    def test_delete_removes_customer(self, writer):
        # Arrange
        customer_id = CustomerId("customer-1")
        
        # Act
        writer.delete(customer_id)
        
        # Assert
        mock_connection.execute.assert_called_with(
            "DELETE FROM customers WHERE id = ?",
            (customer_id.value,)
        )
```

### 5. Dependency Inversion Principle (DIP)

Test against abstractions using dependency injection.

**TypeScript Example:**
```typescript
// Service interface
interface IProductService {
  getProducts(): Promise<Product[]>;
  getProductById(id: number): Promise<Product | null>;
}

// Mock implementation for testing
class MockProductService implements IProductService {
  private products: Product[] = [
    { id: 1, name: 'Product A', price: 10.00 },
    { id: 2, name: 'Product B', price: 20.00 },
  ];

  async getProducts(): Promise<Product[]> {
    return this.products;
  }

  async getProductById(id: number): Promise<Product | null> {
    return this.products.find(p => p.id === id) || null;
  }
}

// Test with injected dependency
describe('OrderService', () => {
  let productService: IProductService;
  let orderService: OrderService;

  beforeEach(() => {
    productService = new MockProductService();
    orderService = new OrderService(productService);
  });

  it('should create order with products', async () => {
    // Arrange
    const customerId = 1;
    const productIds = [1, 2];

    // Act
    const order = await orderService.createOrder(customerId, productIds);

    // Assert
    expect(order.items).toHaveLength(2);
    expect(order.total).toBe(30.00);
  });

  it('should handle missing products gracefully', async () => {
    // Arrange
    const customerId = 1;
    const productIds = [999]; // Non-existent product

    // Act & Assert
    await expect(
      orderService.createOrder(customerId, productIds)
    ).rejects.toThrow('Product not found: 999');
  });
});

// Test with different implementation
class ErrorProductService implements IProductService {
  async getProducts(): Promise<Product[]> {
    throw new Error('Database connection failed');
  }

  async getProductById(id: number): Promise<Product | null> {
    throw new Error('Database connection failed');
  }
}

describe('OrderService - Error Handling', () => {
  it('should handle service errors', async () => {
    // Arrange
    const productService = new ErrorProductService();
    const orderService = new OrderService(productService);

    // Act & Assert
    await expect(
      orderService.createOrder(1, [1])
    ).rejects.toThrow('Database connection failed');
  });
});
```

## Mocking Strategies

### When to Use Mocks

✅ **Use mocks for**:
- External dependencies (databases, APIs, file systems)
- Slow operations
- Non-deterministic behavior (random, time)
- Testing error conditions

❌ **Don't mock**:
- Value objects
- Domain entities
- Simple data structures
- Your own code (test real behavior when possible)

### Mock vs Fake

**Mock** - Verifies interactions:
```csharp
var mock = new Mock<IEmailService>();
service.SendWelcomeEmail(customer);
mock.Verify(m => m.Send(It.IsAny<Email>()), Times.Once);
```

**Fake** - Provides working implementation:
```csharp
public class FakeEmailService : IEmailService
{
    public List<Email> SentEmails { get; } = new();
    
    public void Send(Email email)
    {
        SentEmails.Add(email);
    }
}
```

## Test Data Builders

Create reusable test data builders:

**C# Example:**
```csharp
public class CustomerBuilder
{
    private CustomerId _id = new CustomerId(1);
    private string _name = "John Doe";
    private EmailAddress _email = new EmailAddress("john@example.com");
    private CustomerStatus _status = CustomerStatus.Active;

    public CustomerBuilder WithId(int id)
    {
        _id = new CustomerId(id);
        return this;
    }

    public CustomerBuilder WithName(string name)
    {
        _name = name;
        return this;
    }

    public CustomerBuilder WithEmail(string email)
    {
        _email = new EmailAddress(email);
        return this;
    }

    public CustomerBuilder Inactive()
    {
        _status = CustomerStatus.Inactive;
        return this;
    }

    public Customer Build()
    {
        return new Customer(_id, _name, _email, _status);
    }
}

// Usage in tests
[Fact]
public void ProcessOrder_ShouldFail_WhenCustomerInactive()
{
    // Arrange
    var customer = new CustomerBuilder()
        .WithId(1)
        .Inactive()
        .Build();

    // Act & Assert
    Assert.Throws<InvalidOperationException>(() => 
        orderService.ProcessOrder(customer, order)
    );
}
```

## Integration Testing

### Database Integration Tests

**C# with TestContainers:**
```csharp
public class CustomerRepositoryIntegrationTests : IAsyncLifetime
{
    private PostgreSqlContainer _container;
    private IDbConnection _connection;
    private CustomerRepository _repository;

    public async Task InitializeAsync()
    {
        _container = new PostgreSqlBuilder()
            .WithDatabase("testdb")
            .WithUsername("test")
            .WithPassword("test")
            .Build();

        await _container.StartAsync();

        _connection = new NpgsqlConnection(_container.GetConnectionString());
        await _connection.OpenAsync();
        
        // Run migrations
        await RunMigrations(_connection);
        
        _repository = new CustomerRepository(_connection);
    }

    [Fact]
    public async Task Save_ShouldPersistCustomerToRealDatabase()
    {
        // Arrange
        var customer = new Customer(
            new CustomerId(1),
            "John Doe",
            new EmailAddress("john@example.com")
        );

        // Act
        await _repository.Save(customer);

        // Assert
        var retrieved = await _repository.FindById(customer.Id);
        retrieved.Should().NotBeNull();
        retrieved.Name.Should().Be("John Doe");
    }

    public async Task DisposeAsync()
    {
        await _connection.DisposeAsync();
        await _container.DisposeAsync();
    }
}
```

## Best Practices

### ✅ Do's

- Test one thing per test
- Use descriptive test names
- Follow Arrange-Act-Assert pattern
- Keep tests independent
- Use test builders for complex objects
- Mock external dependencies
- Test edge cases and error conditions
- Maintain tests like production code

### ❌ Don'ts

- Don't test private methods directly
- Don't share state between tests
- Don't test framework code
- Don't write brittle tests
- Don't ignore failing tests
- Don't skip cleanup
- Don't over-mock

## Troubleshooting

### Common Issues

**Flaky Tests**
- Use fixed test data
- Avoid time-dependent tests
- Clean up after each test
- Don't rely on test execution order

**Slow Tests**
- Mock external dependencies
- Use in-memory databases
- Parallelize test execution
- Profile and optimize

**Hard to Test Code**
- Sign of poor design
- Refactor to follow SOLID
- Inject dependencies
- Separate concerns

## Next Steps

1. Review [Testing Workshop](../TESTING-WORKSHOP.md)
2. Complete testing exercises for each SOLID principle
3. Use [Assessment Checklist](../ASSESSMENT-CHECKLIST.md)
4. Explore language-specific testing frameworks

---

**Remember**: Tests are your safety net. Write them before refactoring, keep them green, and let them guide your design.
