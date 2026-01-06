# C# Testing Patterns for SOLID Principles

## Overview

This guide covers common testing patterns for C# backend development, specifically focused on testing code that follows SOLID principles. You'll learn how to structure tests, use xUnit features effectively, and test each SOLID principle.

## Testing Stack

- **xUnit** - Test framework
- **Moq** - Mocking library
- **FluentAssertions** - Assertion library
- **AutoFixture** - Test data generation

## Basic Test Structure

### Arrange-Act-Assert (AAA) Pattern

```csharp
[Fact]
public void MethodName_Condition_ExpectedResult()
{
    // Arrange - Set up test data and dependencies
    var dependency = new Mock<IDependency>();
    var sut = new SystemUnderTest(dependency.Object);
    
    // Act - Execute the method being tested
    var result = sut.MethodToTest();
    
    // Assert - Verify the expected outcome
    result.Should().Be(expectedValue);
}
```

### Using Theory for Parameterized Tests

```csharp
[Theory]
[InlineData(10, 2, 20)]
[InlineData(15, 3, 45)]
[InlineData(0, 5, 0)]
public void CalculateTotal_ShouldMultiplyPriceByQuantity(
    decimal price, 
    int quantity, 
    decimal expected)
{
    // Arrange
    var calculator = new PriceCalculator();
    
    // Act
    var result = calculator.CalculateTotal(price, quantity);
    
    // Assert
    result.Should().Be(expected);
}
```

## Testing SOLID Principles

### 1. Single Responsibility Principle (SRP)

Test each responsibility independently.

#### Before SRP - God Class

```csharp
// Hard to test - too many responsibilities
public class EcommerceManager
{
    public void CreateCustomer(Customer customer)
    {
        // Validates
        // Saves to database
        // Sends email
        // Logs activity
    }
}

// Test is complex and brittle
[Fact]
public void CreateCustomer_DoesEverything()
{
    var mockDb = new Mock<IDatabase>();
    var mockEmail = new Mock<IEmailService>();
    var mockLogger = new Mock<ILogger>();
    var manager = new EcommerceManager(mockDb.Object, mockEmail.Object, mockLogger.Object);
    
    manager.CreateCustomer(customer);
    
    // Too many verifications
    mockDb.Verify(/*...*/);
    mockEmail.Verify(/*...*/);
    mockLogger.Verify(/*...*/);
}
```

#### After SRP - Focused Classes

```csharp
// Easy to test - single responsibility
public class CustomerValidator
{
    public ValidationResult Validate(Customer customer)
    {
        if (string.IsNullOrEmpty(customer.Email))
            return ValidationResult.Failure("Email is required");
        
        if (!IsValidEmail(customer.Email))
            return ValidationResult.Failure("Invalid email format");
        
        return ValidationResult.Success();
    }
}

// Focused test
[Fact]
public void Validate_ShouldFail_WhenEmailEmpty()
{
    // Arrange
    var validator = new CustomerValidator();
    var customer = new Customer { Email = "" };
    
    // Act
    var result = validator.Validate(customer);
    
    // Assert
    result.IsValid.Should().BeFalse();
    result.Errors.Should().Contain("Email is required");
}

[Theory]
[InlineData("invalid")]
[InlineData("@example.com")]
[InlineData("user@")]
public void Validate_ShouldFail_WhenEmailInvalid(string invalidEmail)
{
    // Arrange
    var validator = new CustomerValidator();
    var customer = new Customer { Email = invalidEmail };
    
    // Act
    var result = validator.Validate(customer);
    
    // Assert
    result.IsValid.Should().BeFalse();
    result.Errors.Should().Contain("Invalid email format");
}
```

### 2. Open/Closed Principle (OCP)

Test base behavior and extensions independently.

#### Strategy Pattern Testing

```csharp
// Interface
public interface IDiscountStrategy
{
    Money ApplyDiscount(Money originalPrice);
}

// Implementations
public class PercentageDiscount : IDiscountStrategy
{
    private readonly decimal _percentage;
    
    public PercentageDiscount(decimal percentage)
    {
        _percentage = percentage;
    }
    
    public Money ApplyDiscount(Money originalPrice)
    {
        var discount = originalPrice.Amount * (_percentage / 100);
        return new Money(originalPrice.Amount - discount, originalPrice.Currency);
    }
}

// Test base contract
public abstract class DiscountStrategyContractTests
{
    protected abstract IDiscountStrategy CreateStrategy();
    
    [Fact]
    public void ApplyDiscount_ShouldNotReturnNegativePrice()
    {
        // Arrange
        var strategy = CreateStrategy();
        var price = new Money(10.00m, Currency.USD);
        
        // Act
        var result = strategy.ApplyDiscount(price);
        
        // Assert
        result.Amount.Should().BeGreaterThanOrEqualTo(0);
    }
    
    [Fact]
    public void ApplyDiscount_ShouldPreserveCurrency()
    {
        // Arrange
        var strategy = CreateStrategy();
        var price = new Money(100.00m, Currency.EUR);
        
        // Act
        var result = strategy.ApplyDiscount(price);
        
        // Assert
        result.Currency.Should().Be(Currency.EUR);
    }
}

// Test specific implementation
public class PercentageDiscountTests : DiscountStrategyContractTests
{
    protected override IDiscountStrategy CreateStrategy()
    {
        return new PercentageDiscount(10);
    }
    
    [Theory]
    [InlineData(100.00, 10, 90.00)]
    [InlineData(50.00, 20, 40.00)]
    [InlineData(75.00, 15, 63.75)]
    public void ApplyDiscount_ShouldCalculateCorrectPercentage(
        decimal original, 
        decimal percentage, 
        decimal expected)
    {
        // Arrange
        var strategy = new PercentageDiscount(percentage);
        var price = new Money(original, Currency.USD);
        
        // Act
        var result = strategy.ApplyDiscount(price);
        
        // Assert
        result.Amount.Should().Be(expected);
    }
}

// Adding new strategy doesn't require modifying existing tests
public class BuyOneGetOneDiscountTests : DiscountStrategyContractTests
{
    protected override IDiscountStrategy CreateStrategy()
    {
        return new BuyOneGetOneDiscount();
    }
    
    [Fact]
    public void ApplyDiscount_ShouldGive50PercentOff()
    {
        // Arrange
        var strategy = new BuyOneGetOneDiscount();
        var price = new Money(100.00m, Currency.USD);
        
        // Act
        var result = strategy.ApplyDiscount(price);
        
        // Assert
        result.Amount.Should().Be(50.00m);
    }
}
```

### 3. Liskov Substitution Principle (LSP)

Test that derived classes can substitute base classes.

#### Repository Pattern Testing

```csharp
// Base repository contract tests
public abstract class RepositoryContractTests<T, TId> where T : class
{
    protected abstract IRepository<T, TId> CreateRepository();
    protected abstract T CreateEntity(TId id);
    protected abstract TId CreateId();
    
    [Fact]
    public async Task Save_ShouldPersistEntity()
    {
        // Arrange
        var repository = CreateRepository();
        var entity = CreateEntity(CreateId());
        
        // Act
        await repository.SaveAsync(entity);
        
        // Assert
        var retrieved = await repository.FindByIdAsync(GetEntityId(entity));
        retrieved.Should().NotBeNull();
    }
    
    [Fact]
    public async Task FindById_ShouldReturnNull_WhenNotExists()
    {
        // Arrange
        var repository = CreateRepository();
        var nonExistentId = CreateId();
        
        // Act
        var result = await repository.FindByIdAsync(nonExistentId);
        
        // Assert
        result.Should().BeNull();
    }
    
    [Fact]
    public async Task Delete_ShouldRemoveEntity()
    {
        // Arrange
        var repository = CreateRepository();
        var entity = CreateEntity(CreateId());
        await repository.SaveAsync(entity);
        
        // Act
        await repository.DeleteAsync(GetEntityId(entity));
        
        // Assert
        var retrieved = await repository.FindByIdAsync(GetEntityId(entity));
        retrieved.Should().BeNull();
    }
    
    protected abstract TId GetEntityId(T entity);
}

// Concrete implementation tests
public class CustomerRepositoryTests : RepositoryContractTests<Customer, CustomerId>
{
    private readonly Mock<IDbConnection> _mockConnection;
    
    public CustomerRepositoryTests()
    {
        _mockConnection = new Mock<IDbConnection>();
    }
    
    protected override IRepository<Customer, CustomerId> CreateRepository()
    {
        return new CustomerRepository(_mockConnection.Object);
    }
    
    protected override Customer CreateEntity(CustomerId id)
    {
        return new Customer(id, "John Doe", new EmailAddress("john@example.com"));
    }
    
    protected override CustomerId CreateId()
    {
        return new CustomerId(Guid.NewGuid());
    }
    
    protected override CustomerId GetEntityId(Customer entity)
    {
        return entity.Id;
    }
}

// All repository implementations pass the same contract tests
public class OrderRepositoryTests : RepositoryContractTests<Order, OrderId>
{
    // Same pattern for Order repository
}
```

### 4. Interface Segregation Principle (ISP)

Test focused interfaces independently.

#### Before ISP - Fat Interface

```csharp
// Fat interface - hard to test
public interface IRepository
{
    void Save(object entity);
    void Delete(int id);
    object FindById(int id);
    List<object> FindAll();
    List<object> FindByName(string name);
    List<object> FindByDate(DateTime date);
    int Count();
    bool Exists(int id);
    // ... 10 more methods
}

// Test requires mocking many unused methods
[Fact]
public void Service_UsesRepository()
{
    var mockRepo = new Mock<IRepository>();
    // Must setup all methods even if not used
    mockRepo.Setup(r => r.FindById(It.IsAny<int>())).Returns(null);
    mockRepo.Setup(r => r.FindAll()).Returns(new List<object>());
    mockRepo.Setup(r => r.FindByName(It.IsAny<string>())).Returns(new List<object>());
    // ... many more setups
}
```

#### After ISP - Focused Interfaces

```csharp
// Focused interfaces
public interface ICustomerReader
{
    Task<Customer?> FindByIdAsync(CustomerId id);
    Task<Customer?> FindByEmailAsync(EmailAddress email);
}

public interface ICustomerWriter
{
    Task SaveAsync(Customer customer);
    Task DeleteAsync(CustomerId id);
}

// Test only what you need
[Fact]
public async Task GetCustomer_UsesReader()
{
    // Arrange - Only mock what's needed
    var mockReader = new Mock<ICustomerReader>();
    mockReader
        .Setup(r => r.FindByIdAsync(It.IsAny<CustomerId>()))
        .ReturnsAsync(new Customer(new CustomerId(Guid.NewGuid()), "John", new EmailAddress("john@example.com")));
    
    var service = new CustomerDisplayService(mockReader.Object);
    
    // Act
    var result = await service.GetCustomerAsync(new CustomerId(Guid.NewGuid()));
    
    // Assert
    result.Should().NotBeNull();
}

[Fact]
public async Task CreateCustomer_UsesWriter()
{
    // Arrange - Only mock what's needed
    var mockWriter = new Mock<ICustomerWriter>();
    var service = new CustomerManagementService(mockWriter.Object);
    var customer = new Customer(new CustomerId(Guid.NewGuid()), "John", new EmailAddress("john@example.com"));
    
    // Act
    await service.CreateCustomerAsync(customer);
    
    // Assert
    mockWriter.Verify(w => w.SaveAsync(customer), Times.Once);
}
```

### 5. Dependency Inversion Principle (DIP)

Test against abstractions using dependency injection.

#### Testing with Injected Dependencies

```csharp
// Service depends on abstraction
public class OrderService
{
    private readonly IProductRepository _productRepository;
    private readonly IPriceCalculator _priceCalculator;
    private readonly IEmailService _emailService;
    
    public OrderService(
        IProductRepository productRepository,
        IPriceCalculator priceCalculator,
        IEmailService emailService)
    {
        _productRepository = productRepository;
        _priceCalculator = priceCalculator;
        _emailService = emailService;
    }
    
    public async Task<Order> CreateOrderAsync(CustomerId customerId, List<OrderItem> items)
    {
        // Load products
        var products = await _productRepository.FindByIdsAsync(items.Select(i => i.ProductId));
        
        // Calculate total
        var total = _priceCalculator.CalculateTotal(items, products);
        
        // Create order
        var order = new Order(new OrderId(Guid.NewGuid()), customerId, items, total);
        
        // Send confirmation
        await _emailService.SendOrderConfirmationAsync(order);
        
        return order;
    }
}

// Easy to test with mocks
[Fact]
public async Task CreateOrder_ShouldCalculateTotalAndSendEmail()
{
    // Arrange
    var mockProductRepo = new Mock<IProductRepository>();
    var mockCalculator = new Mock<IPriceCalculator>();
    var mockEmailService = new Mock<IEmailService>();
    
    var products = new List<Product>
    {
        new Product(new ProductId(1), "Product 1", new Money(10.00m, Currency.USD)),
        new Product(new ProductId(2), "Product 2", new Money(20.00m, Currency.USD))
    };
    
    mockProductRepo
        .Setup(r => r.FindByIdsAsync(It.IsAny<IEnumerable<ProductId>>()))
        .ReturnsAsync(products);
    
    mockCalculator
        .Setup(c => c.CalculateTotal(It.IsAny<List<OrderItem>>(), It.IsAny<List<Product>>()))
        .Returns(new Money(40.00m, Currency.USD));
    
    var service = new OrderService(
        mockProductRepo.Object,
        mockCalculator.Object,
        mockEmailService.Object
    );
    
    var items = new List<OrderItem>
    {
        new OrderItem(new ProductId(1), 2),
        new OrderItem(new ProductId(2), 1)
    };
    
    // Act
    var order = await service.CreateOrderAsync(new CustomerId(Guid.NewGuid()), items);
    
    // Assert
    order.Total.Amount.Should().Be(40.00m);
    mockEmailService.Verify(
        e => e.SendOrderConfirmationAsync(It.Is<Order>(o => o.Total.Amount == 40.00m)),
        Times.Once
    );
}

// Easy to test with different implementations
[Fact]
public async Task CreateOrder_WorksWithDifferentCalculator()
{
    // Arrange - Use different calculator implementation
    var mockProductRepo = new Mock<IProductRepository>();
    var discountCalculator = new DiscountPriceCalculator(0.10m); // 10% discount
    var mockEmailService = new Mock<IEmailService>();
    
    mockProductRepo
        .Setup(r => r.FindByIdsAsync(It.IsAny<IEnumerable<ProductId>>()))
        .ReturnsAsync(new List<Product>
        {
            new Product(new ProductId(1), "Product", new Money(100.00m, Currency.USD))
        });
    
    var service = new OrderService(
        mockProductRepo.Object,
        discountCalculator, // Real implementation
        mockEmailService.Object
    );
    
    // Act
    var order = await service.CreateOrderAsync(
        new CustomerId(Guid.NewGuid()),
        new List<OrderItem> { new OrderItem(new ProductId(1), 1) }
    );
    
    // Assert
    order.Total.Amount.Should().Be(90.00m); // 10% discount applied
}
```

## Advanced Testing Patterns

### Test Fixtures for Shared Setup

```csharp
public class DatabaseFixture : IDisposable
{
    public IDbConnection Connection { get; }
    
    public DatabaseFixture()
    {
        Connection = CreateConnection();
        SeedDatabase();
    }
    
    private IDbConnection CreateConnection()
    {
        // Create test database connection
        return new NpgsqlConnection("connection-string");
    }
    
    private void SeedDatabase()
    {
        // Insert test data
    }
    
    public void Dispose()
    {
        Connection?.Dispose();
    }
}

[CollectionDefinition("Database")]
public class DatabaseCollection : ICollectionFixture<DatabaseFixture>
{
}

[Collection("Database")]
public class CustomerRepositoryTests
{
    private readonly DatabaseFixture _fixture;
    
    public CustomerRepositoryTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }
    
    [Fact]
    public async Task Save_ShouldPersistToDatabase()
    {
        var repository = new CustomerRepository(_fixture.Connection);
        // Test using shared fixture
    }
}
```

### Custom Assertions

```csharp
public static class CustomerAssertions
{
    public static void ShouldBeValidCustomer(this Customer customer)
    {
        customer.Should().NotBeNull();
        customer.Id.Should().NotBeNull();
        customer.Name.Should().NotBeNullOrEmpty();
        customer.Email.Should().NotBeNull();
        customer.Email.Value.Should().Contain("@");
    }
}

// Usage
[Fact]
public void CreateCustomer_ShouldReturnValidCustomer()
{
    var customer = _service.CreateCustomer("John", "john@example.com");
    customer.ShouldBeValidCustomer();
}
```

### Test Data Builders

```csharp
public class OrderBuilder
{
    private OrderId _id = new OrderId(Guid.NewGuid());
    private CustomerId _customerId = new CustomerId(Guid.NewGuid());
    private List<OrderItem> _items = new();
    private Money _total = new Money(0, Currency.USD);
    
    public OrderBuilder WithId(OrderId id)
    {
        _id = id;
        return this;
    }
    
    public OrderBuilder ForCustomer(CustomerId customerId)
    {
        _customerId = customerId;
        return this;
    }
    
    public OrderBuilder WithItem(ProductId productId, int quantity)
    {
        _items.Add(new OrderItem(productId, quantity));
        return this;
    }
    
    public OrderBuilder WithTotal(Money total)
    {
        _total = total;
        return this;
    }
    
    public Order Build()
    {
        return new Order(_id, _customerId, _items, _total);
    }
}

// Usage
[Fact]
public void ProcessOrder_ShouldHandleMultipleItems()
{
    var order = new OrderBuilder()
        .ForCustomer(new CustomerId(Guid.NewGuid()))
        .WithItem(new ProductId(1), 2)
        .WithItem(new ProductId(2), 1)
        .WithTotal(new Money(40.00m, Currency.USD))
        .Build();
    
    var result = _service.ProcessOrder(order);
    result.Should().BeTrue();
}
```

## Summary

**Key Testing Patterns**:
- Use AAA pattern consistently
- Test each SOLID principle appropriately
- Use Theory for parameterized tests
- Create contract tests for LSP
- Use focused interfaces for ISP
- Inject dependencies for DIP
- Use test builders for complex objects
- Create custom assertions for domain concepts

## Next Steps

1. Review [Mocking with Moq](./02-MOCKING.md)
2. Learn [Integration Testing](./03-INTEGRATION-TESTING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Good testing patterns make your tests maintainable and your code more testable. Follow SOLID principles in both production and test code.
